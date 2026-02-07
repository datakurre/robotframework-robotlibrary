"""RobotLibrary - Test Robot Framework tests and tasks within Robot Framework.

RobotLibrary enables testing Robot Framework test and task files from within
Robot Framework itself, without subprocess execution. It uses the Listener v3
API to dynamically inject test steps at runtime.

Usage in Robot Framework::

    *** Settings ***
    Library    RobotLibrary

    *** Test Cases ***
    Test With Default Variables
        Run Robot Test    target.robot    Login Test

    Test With Custom Variables
        Run Robot Test    target.robot    Login Test
        ...    USERNAME=testuser
        ...    PASSWORD=secret123

For RPA task suites (``*** Tasks ***``), the ``Run Robot Task`` alias can
be used::

    *** Settings ***
    Library    RobotLibrary

    *** Tasks ***
    Process With Defaults
        Run Robot Task    tasks.robot    Process Invoice

    Process With Overrides
        Run Robot Task    tasks.robot    Process Invoice
        ...    SOURCE=file.csv

See the ``Run Robot Test`` and ``Run Robot Task`` keyword documentation for
full details.
"""

from RobotLibrary._listener import RobotLibraryListener
from RobotLibrary._version import __version__

from pathlib import Path
from robot.api import logger, TestSuite
from robot.api.deco import keyword, library
from robot.running.model import Keyword as RunningKeyword


@library(scope="GLOBAL", listener="SELF")
class RobotLibrary(RobotLibraryListener):
    """Robot Framework library for testing RF tests and tasks within RF.

    This library provides the ``Run Robot Test`` and ``Run Robot Task``
    keywords that enable running tests or tasks from external ``.robot``
    files inside the current test/task execution. Steps from the target
    test/task are injected into the calling test's body at runtime.

    ``Run Robot Task`` is a convenience alias for ``Run Robot Test`` that
    improves readability when working with RPA task suites (files using
    ``*** Tasks ***`` instead of ``*** Test Cases ***).

    == How it works ==

    1. A test/task calls ``Run Robot Test`` (or ``Run Robot Task``).
    2. The library's Listener v3 ``start_test`` method fires before execution.
    3. The target ``.robot`` file is parsed and the named test/task is located.
    4. Resource imports from the target suite are loaded via ``Import Resource``.
    5. Variables (scalar, list, dict) from the target suite are injected as
       ``Set Test Variable`` calls.
    6. ``[Setup]`` and ``[Teardown]`` from the target test/task are injected as
       body steps.
    7. All test/task body steps (including control structures) are deep-copied
       and injected into the calling test's body.
    8. The original marker keyword is removed, resulting in clean logs.

    == Features ==

    - *No subprocess execution* — tests run in the same Python process.
    - *Control structures* — FOR, IF, WHILE, TRY/EXCEPT, BREAK, CONTINUE work.
    - *Setup/teardown* — ``[Setup]`` and ``[Teardown]`` from target tests/tasks
      are injected.
    - *Resource imports* — resource files imported by the target suite are
      auto-imported.
    - *Variable override* — scalar, list, and dict variables can be overridden.
    - *Clean logs* — injected steps appear directly in the test body.
    - *Suite caching* — parsed suites are cached for performance.
    - *Works with both tests and tasks* — ``Run Robot Test`` and
      ``Run Robot Task`` both work with ``*** Test Cases ***`` and
      ``*** Tasks ***`` suites.
    - *Task-level settings* — ``Task Setup``, ``Task Teardown``,
      ``Task Template`` and ``Task Timeout`` in target suites are honoured.

    == Example with Test Cases ==

    Target suite (``login.robot``):
    | *** Variables ***
    | ${USERNAME}    default_user
    | ${PASSWORD}    default_pass
    |
    | *** Test Cases ***
    | Login Test
    |     Log    Logging in as ${USERNAME}
    |     Should Not Be Empty    ${USERNAME}
    |     Should Not Be Empty    ${PASSWORD}

    Meta-test suite (``test_login.robot``):
    | *** Settings ***
    | Library    RobotLibrary
    |
    | *** Test Cases ***
    | Test Login With Defaults
    |     Run Robot Test    login.robot    Login Test
    |
    | Test Login With Custom Credentials
    |     Run Robot Test    login.robot    Login Test
    |     ...    USERNAME=admin    PASSWORD=secret

    == Example with Tasks (RPA) ==

    Target task suite (``process.robot``):
    | *** Variables ***
    | ${SOURCE}    default.csv
    |
    | *** Tasks ***
    | Process Invoice
    |     Log    Processing from ${SOURCE}
    |     Should Not Be Empty    ${SOURCE}

    Meta-test suite (``test_process.robot``):
    | *** Settings ***
    | Library    RobotLibrary
    |
    | *** Test Cases ***
    | Test Process With Defaults
    |     Run Robot Task    process.robot    Process Invoice
    |
    | Test Process With Custom Source
    |     Run Robot Task    process.robot    Process Invoice
    |     ...    SOURCE=invoices.csv
    """

    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        """Initialize the library.

        Creates a suite cache for performance (avoids re-parsing the same
        ``.robot`` files) and registers the library as a Listener v3.
        """
        self._suite_cache: dict[Path, TestSuite] = {}

    @keyword("Run Robot Test")
    def run_robot_test(self, suite_path: str, test_name: str, **variables: str) -> str:
        """Run a test or task from another Robot Framework suite file.

        This keyword acts as a *marker* that is replaced at runtime by the
        library's listener. The actual steps from the target test/task are
        injected into the calling test's body before execution begins.

        Arguments:
        - ``suite_path``: Path to the ``.robot`` file (absolute, or relative
          to the directory of the calling suite).
        - ``test_name``: Name of the test case or task to run.
        - ``**variables``: Variable overrides as ``NAME=value`` pairs. These
          override variables defined in the target suite's
          ``*** Variables ***`` section.

        Returns an error message if injection fails (i.e., the listener did
        not replace this marker).

        Examples:
        | Run Robot Test | tests/login.robot | Valid Login |
        | Run Robot Test | ${CURDIR}/api.robot | GET Request | API_URL=http://localhost |

        The keyword also works with ``Test Template`` for data-driven testing:
        | *** Settings ***
        | Library          RobotLibrary
        | Test Template    Run Robot Test
        |
        | *** Test Cases ***    suite_path              test_name    NAME
        | Log John              ${CURDIR}/tasks.robot   Log name     John
        | Log Jane              ${CURDIR}/tasks.robot   Log name     Jane
        """
        return f"ERROR: Injection failed for test '{test_name}'"

    @keyword("Run Robot Task")
    def run_robot_task(self, suite_path: str, task_name: str, **variables: str) -> str:
        """Run a task from another Robot Framework suite file.

        This is an alias for ``Run Robot Test`` intended for use with RPA
        task suites (files using ``*** Tasks ***`` instead of
        ``*** Test Cases ***``).  It works identically — the target task's
        steps are injected into the calling test or task at runtime.

        Arguments:
        - ``suite_path``: Path to the ``.robot`` file containing tasks.
        - ``task_name``: Name of the task to run.
        - ``**variables``: Variable overrides as ``NAME=value`` pairs.

        Examples:
        | Run Robot Task | tasks/process_invoice.robot | Process Invoice |
        | Run Robot Task | ${CURDIR}/rpa.robot | Data Entry | SOURCE=file.csv |

        The keyword works with both ``Test Template`` and ``Task Template``:
        | *** Settings ***
        | Library          RobotLibrary
        | Task Template    Run Robot Task
        |
        | *** Tasks ***         suite_path              task_name    NAME
        | Process John          ${CURDIR}/tasks.robot   Log name     John
        | Process Jane          ${CURDIR}/tasks.robot   Log name     Jane
        """
        return f"ERROR: Injection failed for task '{task_name}'"

    # -- Suite loading and test lookup ----------------------------------------

    def _load_suite(self, suite_path: str) -> TestSuite:
        """Load and cache a test suite from a ``.robot`` file.

        Args:
            suite_path: Resolved absolute path to the ``.robot`` file.

        Returns:
            Parsed ``TestSuite`` object.
        """
        resolved = Path(suite_path).resolve()

        if resolved not in self._suite_cache:
            logger.debug(f"Parsing suite: {resolved}")
            self._suite_cache[resolved] = TestSuite.from_file_system(resolved)

        return self._suite_cache[resolved]

    def _find_test(self, suite: TestSuite, test_name: str):
        """Find a test case or task by name in a suite.

        Args:
            suite: Parsed ``TestSuite``.
            test_name: Exact name of the test or task.

        Returns:
            The matching test/task model object, or ``None``.
        """
        for test in suite.tests:
            if test.name == test_name:
                return test
        return None

    # -- Variable helpers -----------------------------------------------------

    @staticmethod
    def _parse_variable_overrides(args) -> dict[str, str]:
        """Parse ``KEY=value`` variable overrides from keyword arguments.

        Args:
            args: Iterable of argument strings in ``KEY=value`` format.

        Returns:
            Dictionary mapping variable names to values.
        """
        variables: dict[str, str] = {}
        for arg in args:
            arg_str = str(arg)
            if "=" in arg_str:
                var_name, var_value = arg_str.split("=", 1)
                variables[var_name.strip()] = var_value
        return variables

    @staticmethod
    def _create_set_variable_keyword(name: str, value) -> RunningKeyword:
        """Create a ``Set Test Variable`` keyword call.

        Handles scalar (``${}``) , list (``@{}``) and dictionary (``&{}``)
        variables.  For list and dict variables the individual items are
        passed as separate arguments so that ``Set Test Variable`` receives
        them correctly.

        Args:
            name: Variable name including its ``${}``, ``@{}`` or ``&{}``
                  wrapper.
            value: Variable value – a single string for scalars, or a tuple /
                   list of strings for list and dict variables.

        Returns:
            A ``RunningKeyword`` model object.
        """
        if isinstance(value, (list, tuple)) and (
            name.startswith("@{") or name.startswith("&{")
        ):
            return RunningKeyword(
                name="BuiltIn.Set Test Variable",
                args=[name, *value],
            )
        return RunningKeyword(
            name="BuiltIn.Set Test Variable",
            args=[name, value],
        )
