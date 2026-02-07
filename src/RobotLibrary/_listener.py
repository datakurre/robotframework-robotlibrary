"""Listener v3 mixin for RobotLibrary.

Implements the Listener v3 ``start_test`` and ``end_test`` hooks that perform
the runtime injection of test/task steps from target suites into the calling
test or task.  The ``start_test`` hook fires for both tests and tasks.
"""

from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn


class RobotLibraryListener:
    """Mixin providing Listener v3 hooks for test/task step injection.

    This class is designed to be used as a base for ``RobotLibrary``. It
    expects the subclass to provide:

    - ``_load_suite(suite_path)``
    - ``_find_test(suite, test_name)``
    - ``_parse_variable_overrides(args)``
    - ``_create_set_variable_keyword(name, value)``
    """

    def start_test(self, data, result):
        """Listener v3 hook — inject test steps before test execution.

        Called by Robot Framework before each test starts. Finds all
        ``Run Robot Test`` markers in the test body and replaces them with
        actual test steps from target test files.

        Args:
            data: Running test model (mutable).
            result: Result object (read-only at this point).
        """
        self._inject_test_steps(data)

    def end_test(self, data, result):
        """Listener v3 hook — called after test execution completes.

        Args:
            data: Running test model.
            result: Result object with test outcome.
        """

    # -- Injection pipeline ---------------------------------------------------

    _MARKER_KEYWORDS = frozenset({"Run Robot Test", "Run Robot Task"})

    def _inject_test_steps(self, test_data):
        """Find and replace all ``Run Robot Test`` / ``Run Robot Task`` markers.

        Processes markers in reverse order to maintain correct indices after
        each insertion/removal.

        Args:
            test_data: Running test model to modify.
        """
        markers = [
            (idx, item)
            for idx, item in enumerate(test_data.body)
            if hasattr(item, "name") and item.name in self._MARKER_KEYWORDS
        ]

        if not markers:
            return

        logger.info(
            f"Found {len(markers)} Run Robot Test/Task marker(s) in '{test_data.name}'"
        )

        for marker_idx, marker in reversed(markers):
            try:
                self._process_marker(test_data, marker_idx, marker)
            except Exception as e:
                logger.error(f"Failed to process marker at index {marker_idx}: {e}")

    def _process_marker(self, test_data, marker_idx, marker):
        """Process a single ``Run Robot Test`` marker.

        Extracts arguments, loads the target test suite, and injects the
        steps into the calling test.

        Args:
            test_data: Running test model to modify.
            marker_idx: Index of the marker in the test body.
            marker: The marker keyword model object.
        """
        if not hasattr(marker, "args") or len(marker.args) < 2:
            logger.warn(
                "Run Robot Test requires at least 2 arguments: suite_path and test_name"
            )
            return

        # Resolve Robot Framework variables in arguments
        try:
            builtin = BuiltIn()
            suite_path = builtin.replace_variables(str(marker.args[0]))
            test_name = builtin.replace_variables(str(marker.args[1]))
        except Exception as e:
            logger.debug(f"Could not resolve variables in marker arguments: {e}")
            return

        # Parse variable overrides from remaining arguments
        variables = self._parse_variable_overrides(marker.args[2:])

        logger.info(f"Injecting: {suite_path} / {test_name}")

        # Load the target suite and locate the test/task
        suite = self._load_suite(suite_path)
        target_test = self._find_test(suite, test_name)

        if not target_test:
            logger.error(f"Test or task '{test_name}' not found in {suite_path}")
            return

        # Perform the injection
        self._inject_variables_and_steps(
            test_data, marker_idx, suite, target_test, variables
        )

        logger.info(
            f"Successfully injected {len(target_test.body)} step(s) from '{test_name}'"
        )

    def _inject_variables_and_steps(
        self, test_data, marker_idx, suite, target_test, overrides
    ):
        """Replace a marker with variable setup keywords and test steps.

        Args:
            test_data: Running test model to modify.
            marker_idx: Index of the marker to replace.
            suite: Target ``TestSuite`` (provides the variable table).
            target_test: Target test/task (provides the steps to inject).
            overrides: Variable overrides from keyword arguments.
        """
        variable_steps = []

        # Inject variables from the target suite's *** Variables *** section
        if hasattr(suite, "resource") and hasattr(suite.resource, "variables"):
            for var in suite.resource.variables:
                if hasattr(var, "name") and hasattr(var, "value"):
                    if var.name.startswith(("@{", "&{")):
                        # List / dict variables: keep the full tuple
                        var_value = var.value
                    elif isinstance(var.value, (list, tuple)) and var.value:
                        # Scalar variables: unwrap the single-element tuple
                        var_value = var.value[0]
                    else:
                        var_value = var.value
                    variable_steps.append(
                        self._create_set_variable_keyword(var.name, var_value)
                    )

        # Apply overrides (these take precedence)
        if overrides:
            logger.info(f"Applying variable overrides: {list(overrides.keys())}")
            for var_name, var_value in overrides.items():
                if not var_name.startswith("${"):
                    var_name = f"${{{var_name}}}"
                variable_steps.append(
                    self._create_set_variable_keyword(var_name, var_value)
                )

        # Build resource import steps so that keywords from the target
        # suite's resource files are available in the calling test's scope.
        import_steps = []
        if hasattr(suite, "resource") and hasattr(suite.resource, "imports"):
            from pathlib import Path
            from robot.running.model import Keyword as RunningKeyword

            suite_dir = Path(str(suite.source)).parent if suite.source else None
            for imp in suite.resource.imports:
                if imp.type == "RESOURCE":
                    imp_path = imp.name
                    # Resolve relative paths against the target suite dir
                    if suite_dir and not Path(imp_path).is_absolute():
                        imp_path = str(suite_dir / imp_path)
                    import_steps.append(
                        RunningKeyword(
                            name="BuiltIn.Import Resource",
                            args=[imp_path],
                        )
                    )

        # Collect setup / teardown steps from the target test.
        # These are injected as regular body steps (first / last) rather
        # than using test_data.setup / .teardown, which keeps the logic
        # simple and avoids RF-internal fixture resolution quirks.
        setup_steps = []
        if target_test.setup and target_test.setup.name:
            from robot.running.model import Keyword as RunningKeyword

            setup_steps.append(
                RunningKeyword(
                    name=target_test.setup.name,
                    args=list(target_test.setup.args),
                )
            )

        teardown_steps = []
        if target_test.teardown and target_test.teardown.name:
            from robot.running.model import Keyword as RunningKeyword

            teardown_steps.append(
                RunningKeyword(
                    name=target_test.teardown.name,
                    args=list(target_test.teardown.args),
                )
            )

        # Remove the marker keyword
        test_data.body.pop(marker_idx)

        # Build the full list of steps to inject:
        #   1. resource imports
        #   2. variable setup
        #   3. target test [Setup] (as a regular keyword call)
        #   4. target test body
        #   5. target test [Teardown] (as a regular keyword call)
        injected = import_steps + variable_steps + setup_steps
        for step in target_test.body:
            injected.append(step.deepcopy())
        injected.extend(teardown_steps)

        for idx, step in enumerate(injected):
            test_data.body.insert(marker_idx + idx, step)
