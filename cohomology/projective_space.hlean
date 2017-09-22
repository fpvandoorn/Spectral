/- A computation of the cohomology groups of K(ℤ,2) using the Serre spectral sequence

Author: Floris van Doorn-/

import .serre

open spectrum EM EM.ops int pointed cohomology left_module algebra group fiber is_equiv equiv

namespace temp

  definition f : unit → K agℤ 2 :=
  λx, pt

  definition serre_convergence_map_of_is_conn :
    (λn s, uoH^-(n-s)[K agℤ 2, H^-s[circle₊]]) ⟹ᵍ (λn, H^-n[unit₊]) :=
  proof
  converges_to_g_isomorphism
    (serre_convergence_map_of_is_conn pt f (EM_spectrum agℤ) 0
      (is_strunc_EM_spectrum agℤ) (is_conn_EM agℤ 2))
    begin
      intro n s, apply unreduced_ordinary_cohomology_isomorphism_right,
      apply unreduced_cohomology_isomorphism, symmetry,
      refine !fiber_const_equiv ⬝e _,
      refine loop_EM _ 1 ⬝e _,
      exact EM_pequiv_circle
    end
    begin intro n, reflexivity end
  qed

  section
    local notation `X` := converges_to.X serre_convergence_map_of_is_conn
    local notation `E∞` := convergence_theorem.Einf X
  end

end temp
