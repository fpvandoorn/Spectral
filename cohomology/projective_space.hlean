/- A computation of the cohomology groups of K(ℤ,2) using the Serre spectral sequence

Author: Floris van Doorn-/

import .serre

open spectrum EM EM.ops int pointed cohomology left_module algebra group

namespace temp

  definition f : unit → K agℤ 2 :=
  λx, pt

  definition serre_convergence_map_of_is_conn :
    (λn s, uoH^-(n-s)[K agℤ 2, H^-s[circle₊]]) ⟹ᵍ (λn, H^-n[unit₊]) :=
  proof
  converges_to_g_isomorphism
    (serre_convergence_map_of_is_conn pt f (EM_spectrum agℤ) 0
      (is_strunc_EM_spectrum agℤ) (is_conn_EM agℤ 2))
    begin intro n s, end
    begin intro n, reflexivity end
  qed


end temp
