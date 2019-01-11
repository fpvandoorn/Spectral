This folder contains a formalization of various properties about sequential colimits. Most importantly, we prove that sigma-types commute with colimits. It accompanies a submitted paper by Kristina Sojakova, Floris van Doorn and Egbert Rijke.

This repository contains some unproven results, marked by `sorry`. No unproven results are used for any theorems discussed in the paper. You can write `print axioms theoremname` in a file to verify that `sorry` is not used in the proofs.

You will need a working version of Lean 2 to compile this repository. Installation instructions for Lean 2 can be found [here](https://github.com/leanprover/lean2). After that, you can run `linja` (or `path/to/lean2/bin/linja`) from the command-line in the main directory to compile this repository.

The files [`sequence`](sequence.hlean), [`seq_colim`](seq_colim.hlean) and [`pointed`](pointed.hlean) cover all the lemmas, theorems and corollaries in the paper. Some major results of the paper are mentioned in the table below.

| result | file | name |
|--------|---|---|
| Theorem 11 | `seq_colim` | `sigma_seq_colim_over_equiv` |
| Corollary 17 | `seq_colim` | `seq_colim_eq_equiv` |
| Corollary 18 | `pointed` | `pseq_colim_loop` |
| Corollary 21.1 | `seq_colim` | `is_trunc_seq_colim` |
| Corollary 21.2 | `seq_colim` | `trunc_seq_colim_equiv` |
| Corollary 21.3 | `seq_colim` | `is_conn_seq_colim` |