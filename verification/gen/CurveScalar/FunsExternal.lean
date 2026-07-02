-- Hand-written external function models for the Scalar52 arithmetic extraction.
-- This fork (curve25519-dalek v4.1.2) implements Scalar52::sub's constant-time
-- conditional add with a pure arithmetic mask (`constants::L[i] & underflow_mask`),
-- so the function-level scalar extraction pulls in NO external functions
-- (unlike the v5 dalek, which routes sub through subtle, and v4.1.3, which uses
-- a local `black_box`). Kept as a (decl-free) module so the check manifest is
-- uniform across forks.
import Aeneas
import CurveScalar.Types
open Aeneas Aeneas.Std Result ControlFlow Error
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false
set_option maxHeartbeats 1000000
set_option maxRecDepth 2048
open curve25519_dalek
