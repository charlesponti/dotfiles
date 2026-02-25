# Dual-Lane Compute Protocol

## Objective
Isolate high-variance, heavy compute workloads from the core development latency lane.

## Lanes
- Core lane (default): strict deterministic PATH, optimized for edit-test-run throughput.
- Advanced lane (explicit): overlays heavy toolchain paths for AI/ML/inference/experimental workflows.

## Commands
- `lane-core`: resets PATH to `CORE_PATH_BASE`, disables advanced lane flag.
- `lane-advanced`: appends existing advanced candidate paths and sets `ADVANCED_LANE_ACTIVE=true`.

## Invariants
- Advanced tools must not be permanently added to core PATH.
- Core lane SLO budgets remain authoritative for `doctor`.
- Lane transitions are explicit and reversible in one command.

## Resource Governance
Use:
- `resource-scan` for telemetry snapshot.
- `resource-guard --max-swap-gb <n>` to fail-fast on swap/thermal pressure.
