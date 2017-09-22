/-
Copyright (c) 2016 Floris van Doorn. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Floris van Doorn, Ulrik Buchholtz

Reduced cohomology of spectra and cohomology theories
-/

import ..spectrum.basic ..algebra.arrow_group ..homotopy.fwedge ..choice ..homotopy.pushout ..algebra.product_group

open eq spectrum int trunc pointed EM group algebra circle sphere nat EM.ops equiv susp is_trunc
     function fwedge cofiber bool lift sigma is_equiv choice pushout algebra unit pi is_conn

namespace cohomology

/- The cohomology of X with coefficients in Y is
   trunc 0 (A →* Ω[2] (Y (n+2)))
   In the file arrow_group (in algebra) we construct the group structure on this type.
   Equivalently, it's
   πₛ[n] (sp_cotensor X Y)
-/
definition cohomology (X : Type*) (Y : spectrum) (n : ℤ) : AbGroup :=
AbGroup_trunc_pmap X (Y (n+2))

definition ordinary_cohomology [reducible] (X : Type*) (G : AbGroup) (n : ℤ) : AbGroup :=
cohomology X (EM_spectrum G) n

definition ordinary_cohomology_Z [reducible] (X : Type*) (n : ℤ) : AbGroup :=
ordinary_cohomology X agℤ n

definition unreduced_cohomology (X : Type) (Y : spectrum) (n : ℤ) : AbGroup :=
cohomology X₊ Y n

definition unreduced_ordinary_cohomology [reducible] (X : Type) (G : AbGroup) (n : ℤ) : AbGroup :=
unreduced_cohomology X (EM_spectrum G) n

definition unreduced_ordinary_cohomology_Z [reducible] (X : Type) (n : ℤ) : AbGroup :=
unreduced_ordinary_cohomology X agℤ n

definition parametrized_cohomology {X : Type*} (Y : X → spectrum) (n : ℤ) : AbGroup :=
AbGroup_trunc_ppi (λx, Y x (n+2))

definition ordinary_parametrized_cohomology [reducible] {X : Type*} (G : X → AbGroup) (n : ℤ) :
  AbGroup :=
parametrized_cohomology (λx, EM_spectrum (G x)) n

definition unreduced_parametrized_cohomology {X : Type} (Y : X → spectrum) (n : ℤ) : AbGroup :=
parametrized_cohomology (add_point_spectrum Y) n

definition unreduced_ordinary_parametrized_cohomology [reducible] {X : Type} (G : X → AbGroup)
  (n : ℤ) : AbGroup :=
unreduced_parametrized_cohomology (λx, EM_spectrum (G x)) n

notation `H^` n `[`:0 X:0 `, ` Y:0 `]`:0   := cohomology X Y n
notation `oH^` n `[`:0 X:0 `, ` G:0 `]`:0  := ordinary_cohomology X G n
notation `H^` n `[`:0 X:0 `]`:0            := ordinary_cohomology_Z X n
notation `uH^` n `[`:0 X:0 `, ` Y:0 `]`:0  := unreduced_cohomology X Y n
notation `uoH^` n `[`:0 X:0 `, ` G:0 `]`:0 := unreduced_ordinary_cohomology X G n
notation `uH^` n `[`:0 X:0 `]`:0           := unreduced_ordinary_cohomology_Z X n
notation `pH^` n `[`:0 binders `, ` r:(scoped Y, parametrized_cohomology Y n) `]`:0 := r
notation `opH^` n `[`:0 binders `, ` r:(scoped G, ordinary_parametrized_cohomology G n) `]`:0 := r
notation `upH^` n `[`:0 binders `, ` r:(scoped Y, unreduced_parametrized_cohomology Y n) `]`:0 := r
notation `uopH^` n `[`:0 binders `, ` r:(scoped G, unreduced_ordinary_parametrized_cohomology G n) `]`:0 := r

/- an alternate definition of cohomology -/

definition parametrized_cohomology_isomorphism_shomotopy_group_spi {X : Type*} (Y : X → spectrum)
  {n m : ℤ} (p : -m = n) : pH^n[(x : X), Y x] ≃g πₛ[m] (spi X Y) :=
begin
  apply isomorphism.trans (trunc_ppi_loop_isomorphism (λx, Ω (Y x (n + 2))))⁻¹ᵍ,
  apply homotopy_group_isomorphism_of_pequiv 0, esimp,
  have q : sub 2 m = n + 2,
  from (int.add_comm (of_nat 2) (-m) ⬝ ap (λk, k + of_nat 2) p),
  rewrite q, symmetry, apply loop_pppi_pequiv
end

definition unreduced_parametrized_cohomology_isomorphism_shomotopy_group_supi {X : Type}
  (Y : X → spectrum) {n m : ℤ} (p : -m = n) : upH^n[(x : X), Y x] ≃g πₛ[m] (supi X Y) :=
begin
  refine parametrized_cohomology_isomorphism_shomotopy_group_spi (add_point_spectrum Y) p ⬝g _,
  apply shomotopy_group_isomorphism_of_pequiv, intro k,
  apply pppi_add_point_over
end

definition cohomology_isomorphism_shomotopy_group_sp_cotensor (X : Type*) (Y : spectrum) {n m : ℤ}
  (p : -m = n) : H^n[X, Y] ≃g πₛ[m] (sp_cotensor X Y) :=
begin
  refine !trunc_ppi_isomorphic_pmap⁻¹ᵍ ⬝g _,
  refine parametrized_cohomology_isomorphism_shomotopy_group_spi (λx, Y) p ⬝g _,
  apply shomotopy_group_isomorphism_of_pequiv, intro k,
  apply pppi_pequiv_ppmap
end

definition unreduced_cohomology_isomorphism_shomotopy_group_sp_ucotensor (X : Type) (Y : spectrum)
  {n m : ℤ} (p : -m = n) : uH^n[X, Y] ≃g πₛ[m] (sp_ucotensor X Y) :=
begin
  refine cohomology_isomorphism_shomotopy_group_sp_cotensor X₊ Y p ⬝g _,
  apply shomotopy_group_isomorphism_of_pequiv, intro k, apply ppmap_add_point
end

/- functoriality -/

definition cohomology_functor [constructor] {X X' : Type*} (f : X' →* X) (Y : spectrum)
  (n : ℤ) : cohomology X Y n →g cohomology X' Y n :=
Group_trunc_pmap_homomorphism f

definition cohomology_functor_pid (X : Type*) (Y : spectrum) (n : ℤ) (f : H^n[X, Y]) :
  cohomology_functor (pid X) Y n f = f :=
!Group_trunc_pmap_pid

definition cohomology_functor_pcompose {X X' X'' : Type*} (f : X' →* X) (g : X'' →* X')
  (Y : spectrum) (n : ℤ) (h : H^n[X, Y]) : cohomology_functor (f ∘* g) Y n h =
  cohomology_functor g Y n (cohomology_functor f Y n h) :=
!Group_trunc_pmap_pcompose

definition cohomology_functor_phomotopy {X X' : Type*} {f g : X' →* X} (p : f ~* g)
  (Y : spectrum) (n : ℤ) : cohomology_functor f Y n ~ cohomology_functor g Y n :=
Group_trunc_pmap_phomotopy p

definition cohomology_functor_phomotopy_refl {X X' : Type*} (f : X' →* X) (Y : spectrum) (n : ℤ)
  (x : H^n[X, Y]) : cohomology_functor_phomotopy (phomotopy.refl f) Y n x = idp :=
Group_trunc_pmap_phomotopy_refl f x

definition cohomology_functor_pconst {X X' : Type*} (Y : spectrum) (n : ℤ) (f : H^n[X, Y]) :
  cohomology_functor (pconst X' X) Y n f = 1 :=
!Group_trunc_pmap_pconst

definition cohomology_isomorphism {X X' : Type*} (f : X' ≃* X) (Y : spectrum) (n : ℤ) :
  H^n[X, Y] ≃g H^n[X', Y] :=
Group_trunc_pmap_isomorphism f

definition cohomology_isomorphism_refl (X : Type*) (Y : spectrum) (n : ℤ) (x : H^n[X,Y]) :
  cohomology_isomorphism (pequiv.refl X) Y n x = x :=
!Group_trunc_pmap_isomorphism_refl

definition cohomology_isomorphism_right (X : Type*) {Y Y' : spectrum} (e : Πn, Y n ≃* Y' n)
  (n : ℤ) : H^n[X, Y] ≃g H^n[X, Y'] :=
cohomology_isomorphism_shomotopy_group_sp_cotensor X Y !neg_neg ⬝g
shomotopy_group_isomorphism_of_pequiv (-n) (λk, pequiv_ppcompose_left (e k)) ⬝g
(cohomology_isomorphism_shomotopy_group_sp_cotensor X Y' !neg_neg)⁻¹ᵍ

definition unreduced_cohomology_isomorphism {X X' : Type} (f : X' ≃ X) (Y : spectrum) (n : ℤ) :
  uH^n[X, Y] ≃g uH^n[X', Y] :=
cohomology_isomorphism (add_point_pequiv f) Y n

definition unreduced_cohomology_isomorphism_right (X : Type) {Y Y' : spectrum} (e : Πn, Y n ≃* Y' n)
  (n : ℤ) : uH^n[X, Y] ≃g uH^n[X, Y'] :=
cohomology_isomorphism_right X₊ e n

definition unreduced_ordinary_cohomology_isomorphism {X X' : Type} (f : X' ≃ X) (G : AbGroup)
  (n : ℤ) : uoH^n[X, G] ≃g uoH^n[X', G] :=
unreduced_cohomology_isomorphism f (EM_spectrum G) n

definition unreduced_ordinary_cohomology_isomorphism_right (X : Type) {G G' : AbGroup}
  (e : G ≃g G') (n : ℤ) : uoH^n[X, G] ≃g uoH^n[X, G'] :=
unreduced_cohomology_isomorphism_right X (EM_spectrum_pequiv e) n

definition parametrized_cohomology_isomorphism_right {X : Type*} {Y Y' : X → spectrum}
  (e : Πx n, Y x n ≃* Y' x n) (n : ℤ) : pH^n[(x : X), Y x] ≃g pH^n[(x : X), Y' x] :=
parametrized_cohomology_isomorphism_shomotopy_group_spi Y !neg_neg ⬝g
shomotopy_group_isomorphism_of_pequiv (-n) (λk, ppi_pequiv_right (λx, e x k)) ⬝g
(parametrized_cohomology_isomorphism_shomotopy_group_spi Y' !neg_neg)⁻¹ᵍ

definition unreduced_parametrized_cohomology_isomorphism_right {X : Type} {Y Y' : X → spectrum}
  (e : Πx n, Y x n ≃* Y' x n) (n : ℤ) : upH^n[(x : X), Y x] ≃g upH^n[(x : X), Y' x] :=
parametrized_cohomology_isomorphism_right (λx' k, add_point_over_pequiv (λx, e x k) x') n

definition unreduced_ordinary_parametrized_cohomology_isomorphism_right {X : Type}
  {G G' : X → AbGroup} (e : Πx, G x ≃g G' x) (n : ℤ) :
  uopH^n[(x : X), G x] ≃g uopH^n[(x : X), G' x] :=
unreduced_parametrized_cohomology_isomorphism_right (λx, EM_spectrum_pequiv (e x)) n

definition ordinary_cohomology_isomorphism_right (X : Type*) {G G' : AbGroup} (e : G ≃g G')
  (n : ℤ) : oH^n[X, G] ≃g oH^n[X, G'] :=
cohomology_isomorphism_right X (EM_spectrum_pequiv e) n

definition ordinary_parametrized_cohomology_isomorphism_right {X : Type*} {G G' : X → AbGroup}
  (e : Πx, G x ≃g G' x) (n : ℤ) : opH^n[(x : X), G x] ≃g opH^n[(x : X), G' x] :=
parametrized_cohomology_isomorphism_right (λx, EM_spectrum_pequiv (e x)) n

definition uopH_isomorphism_opH {X : Type} (G : X → AbGroup) (n : ℤ) :
  uopH^n[(x : X), G x] ≃g opH^n[(x : X₊), add_point_AbGroup G x] :=
parametrized_cohomology_isomorphism_right
  begin
    intro x n, induction x with x,
    { symmetry, apply EM_spectrum_trivial, },
    { reflexivity }
  end
  n

definition pH_isomorphism_H {X : Type*} (Y : spectrum) (n : ℤ) : pH^n[(x : X), Y] ≃g H^n[X, Y] :=
by reflexivity

definition opH_isomorphism_oH {X : Type*} (G : AbGroup) (n : ℤ) : opH^n[(x : X), G] ≃g oH^n[X, G] :=
by reflexivity

definition upH_isomorphism_uH {X : Type} (Y : spectrum) (n : ℤ) : upH^n[(x : X), Y] ≃g uH^n[X, Y] :=
unreduced_parametrized_cohomology_isomorphism_shomotopy_group_supi _ !neg_neg ⬝g
(unreduced_cohomology_isomorphism_shomotopy_group_sp_ucotensor _ _ !neg_neg)⁻¹ᵍ

definition uopH_isomorphism_uoH {X : Type} (G : AbGroup) (n : ℤ) :
  uopH^n[(x : X), G] ≃g uoH^n[X, G] :=
!upH_isomorphism_uH

definition uopH_isomorphism_uoH_of_is_conn {X : Type*} (G : X → AbGroup) (n : ℤ) (H : is_conn 1 X) :
  uopH^n[(x : X), G x] ≃g uoH^n[X, G pt] :=
begin
  refine _ ⬝g !uopH_isomorphism_uoH,
  apply unreduced_ordinary_parametrized_cohomology_isomorphism_right,
  refine is_conn.elim 0 _ _, reflexivity
end

/- suspension axiom -/

definition cohomology_susp_2 (Y : spectrum) (n : ℤ) :
  Ω (Ω[2] (Y ((n+1)+2))) ≃* Ω[2] (Y (n+2)) :=
begin
  apply loopn_pequiv_loopn 2,
  exact loop_pequiv_loop (pequiv_of_eq (ap Y (add.right_comm n 1 2))) ⬝e* !equiv_glue⁻¹ᵉ*
end

definition cohomology_susp_1 (X : Type*) (Y : spectrum) (n : ℤ) :
  susp X →* Ω (Ω (Y (n + 1 + 2))) ≃ X →* Ω (Ω (Y (n+2))) :=
calc
  susp X →* Ω[2] (Y (n + 1 + 2)) ≃ X →* Ω (Ω[2] (Y (n + 1 + 2))) : susp_adjoint_loop_unpointed
    ... ≃ X →* Ω[2] (Y (n+2)) : equiv_of_pequiv (pequiv_ppcompose_left
                                                  (cohomology_susp_2 Y n))

definition cohomology_susp_1_pmap_mul {X : Type*} {Y : spectrum} {n : ℤ}
  (f g : susp X →* Ω (Ω (Y (n + 1 + 2)))) : cohomology_susp_1 X Y n (pmap_mul f g) ~*
  pmap_mul (cohomology_susp_1 X Y n f) (cohomology_susp_1 X Y n g) :=
begin
  unfold [cohomology_susp_1],
  refine pwhisker_left _ !loop_susp_intro_pmap_mul ⬝* _,
  apply pcompose_pmap_mul
end

definition cohomology_susp_equiv (X : Type*) (Y : spectrum) (n : ℤ) :
  H^n+1[susp X, Y] ≃ H^n[X, Y] :=
trunc_equiv_trunc _ (cohomology_susp_1 X Y n)

definition cohomology_susp (X : Type*) (Y : spectrum) (n : ℤ) :
  H^n+1[susp X, Y] ≃g H^n[X, Y] :=
isomorphism_of_equiv (cohomology_susp_equiv X Y n)
  begin
    intro f₁ f₂, induction f₁ with f₁, induction f₂ with f₂,
    apply ap tr, apply eq_of_phomotopy, exact cohomology_susp_1_pmap_mul f₁ f₂
  end

definition cohomology_susp_natural {X X' : Type*} (f : X →* X') (Y : spectrum) (n : ℤ) :
  cohomology_susp X Y n ∘ cohomology_functor (susp_functor f) Y (n+1) ~
  cohomology_functor f Y n ∘ cohomology_susp X' Y n :=
begin
  refine (trunc_functor_compose _ _ _)⁻¹ʰᵗʸ ⬝hty _ ⬝hty trunc_functor_compose _ _ _,
  apply trunc_functor_homotopy, intro g,
  apply eq_of_phomotopy, refine _ ⬝* !passoc⁻¹*, apply pwhisker_left,
  apply loop_susp_intro_natural
end

/- exactness -/

definition cohomology_exact {X X' : Type*} (f : X →* X') (Y : spectrum) (n : ℤ) :
  is_exact_g (cohomology_functor (pcod f) Y n) (cohomology_functor f Y n) :=
is_exact_trunc_functor (cofiber_exact f)

/- additivity -/

definition additive_hom [constructor] {I : Type} (X : I → Type*) (Y : spectrum) (n : ℤ) :
  H^n[⋁X, Y] →g Πᵍ i, H^n[X i, Y] :=
Group_pi_intro (λi, cohomology_functor (pinl i) Y n)

definition additive_equiv.{u} {I : Type.{u}} (H : has_choice 0 I) (X : I → Type*) (Y : spectrum)
  (n : ℤ) : H^n[⋁X, Y] ≃ Πᵍ i, H^n[X i, Y] :=
trunc_fwedge_pmap_equiv H X (Ω[2] (Y (n+2)))

definition spectrum_additive {I : Type} (H : has_choice 0 I) (X : I → Type*) (Y : spectrum)
  (n : ℤ) : is_equiv (additive_hom X Y n) :=
is_equiv_of_equiv_of_homotopy (additive_equiv H X Y n) begin intro f, induction f, reflexivity end

/- dimension axiom for ordinary cohomology -/
open is_conn trunc_index
theorem EM_dimension' (G : AbGroup) (n : ℤ) (H : n ≠ 0) :
  is_contr (ordinary_cohomology pbool G n) :=
begin
  apply is_conn_equiv_closed 0 !pmap_pbool_equiv⁻¹ᵉ,
  apply is_conn_equiv_closed 0 !equiv_glue2⁻¹ᵉ,
  cases n with n n,
  { cases n with n,
    { exfalso, apply H, reflexivity },
    { apply is_conn_of_le, apply zero_le_of_nat n, exact is_conn_EMadd1 G n, }},
  { apply is_trunc_trunc_of_is_trunc, apply @is_contr_loop_of_is_trunc (n+1) (K G 0),
    apply is_trunc_of_le _ (zero_le_of_nat n) }
end

theorem EM_dimension (G : AbGroup) (n : ℤ) (H : n ≠ 0) :
  is_contr (ordinary_cohomology (plift pbool) G n) :=
@(is_trunc_equiv_closed_rev -2
  (equiv_of_isomorphism (cohomology_isomorphism (pequiv_plift pbool) _ _)))
  (EM_dimension' G n H)

open group algebra
theorem ordinary_cohomology_pbool (G : AbGroup) : ordinary_cohomology pbool G 0 ≃g G :=
sorry
--isomorphism_of_equiv (trunc_equiv_trunc 0 (ppmap_pbool_pequiv _ ⬝e _)  ⬝e !trunc_equiv) sorry

/- cohomology theory -/

structure cohomology_theory.{u} : Type.{u+1} :=
  (HH : ℤ → pType.{u} → AbGroup.{u})
  (Hiso : Π(n : ℤ) {X Y : Type*} (f : X ≃* Y), HH n Y ≃g HH n X)
  (Hiso_refl : Π(n : ℤ) (X : Type*) (x : HH n X), Hiso n pequiv.rfl x = x)
  (Hh : Π(n : ℤ) {X Y : Type*} (f : X →* Y), HH n Y →g HH n X)
  (Hhomotopy : Π(n : ℤ) {X Y : Type*} {f g : X →* Y} (p : f ~* g), Hh n f ~ Hh n g)
  (Hhomotopy_refl : Π(n : ℤ) {X Y : Type*} (f : X →* Y) (x : HH n Y),
    Hhomotopy n (phomotopy.refl f) x = idp)
  (Hid : Π(n : ℤ) {X : Type*} (x : HH n X), Hh n (pid X) x = x)
  (Hcompose : Π(n : ℤ) {X Y Z : Type*} (g : Y →* Z) (f : X →* Y) (z : HH n Z),
    Hh n (g ∘* f) z = Hh n f (Hh n g z))
  (Hsusp : Π(n : ℤ) (X : Type*), HH (succ n) (susp X) ≃g HH n X)
  (Hsusp_natural : Π(n : ℤ) {X Y : Type*} (f : X →* Y),
    Hsusp n X ∘ Hh (succ n) (susp_functor f) ~ Hh n f ∘ Hsusp n Y)
  (Hexact : Π(n : ℤ) {X Y : Type*} (f : X →* Y), is_exact_g (Hh n (pcod f)) (Hh n f))
  (Hadditive : Π(n : ℤ) {I : Type.{u}} (X : I → Type*), has_choice 0 I →
    is_equiv (Group_pi_intro (λi, Hh n (pinl i)) : HH n (⋁ X) → Πᵍ i, HH n (X i)))

structure ordinary_cohomology_theory.{u} extends cohomology_theory.{u} : Type.{u+1} :=
 (Hdimension : Π(n : ℤ), n ≠ 0 → is_contr (HH n (plift pbool)))

attribute cohomology_theory.HH [coercion]
postfix `^→`:90 := cohomology_theory.Hh
open cohomology_theory

definition Hequiv (H : cohomology_theory) (n : ℤ) {X Y : Type*} (f : X ≃* Y) : H n Y ≃ H n X :=
equiv_of_isomorphism (Hiso H n f)

definition Hsusp_neg (H : cohomology_theory) (n : ℤ) (X : Type*) : H n (susp X) ≃g H (pred n) X :=
isomorphism_of_eq (ap (λn, H n _) proof (sub_add_cancel n 1)⁻¹ qed) ⬝g cohomology_theory.Hsusp H (pred n) X

definition Hsusp_neg_natural (H : cohomology_theory) (n : ℤ) {X Y : Type*} (f : X →* Y) :
  Hsusp_neg H n X ∘ H ^→ n (susp_functor f) ~ H ^→ (pred n) f ∘ Hsusp_neg H n Y :=
sorry

definition Hsusp_inv_natural (H : cohomology_theory) (n : ℤ) {X Y : Type*} (f : X →* Y) :
  H ^→ (succ n) (susp_functor f) ∘g (Hsusp H n Y)⁻¹ᵍ ~ (Hsusp H n X)⁻¹ᵍ ∘ H ^→ n f :=
sorry

definition Hsusp_neg_inv_natural (H : cohomology_theory) (n : ℤ) {X Y : Type*} (f : X →* Y) :
  H ^→ n (susp_functor f) ∘g (Hsusp_neg H n Y)⁻¹ᵍ ~ (Hsusp_neg H n X)⁻¹ᵍ ∘ H ^→ (pred n) f :=
sorry

definition Hadditive_equiv (H : cohomology_theory) (n : ℤ) {I : Type} (X : I → Type*) (H2 : has_choice 0 I)
  : H n (⋁ X) ≃g Πᵍ i, H n (X i) :=
isomorphism.mk _ (Hadditive H n X H2)

definition Hlift_empty.{u} (H : cohomology_theory.{u}) (n : ℤ) :
  is_contr (H n (plift punit)) :=
let P : lift empty → Type* := lift.rec empty.elim in
let x := Hadditive H n P _ in
begin
  note z := equiv.mk _ x,
  refine @(is_trunc_equiv_closed_rev -2 (_ ⬝e z ⬝e _)) !is_contr_unit,
    refine Hequiv H n (pequiv_punit_of_is_contr _ _ ⬝e* !pequiv_plift),
    apply is_contr_fwedge_of_neg, intro y, induction y with y, exact y,
  apply equiv_unit_of_is_contr, apply is_contr_pi_of_neg, intro y, induction y with y, exact y
end

definition Hempty (H : cohomology_theory.{0}) (n : ℤ) :
  is_contr (H n punit) :=
@(is_trunc_equiv_closed _ (Hequiv H n !pequiv_plift)) (Hlift_empty H n)

definition Hconst (H : cohomology_theory) (n : ℤ) {X Y : Type*} (y : H n Y) : H ^→ n (pconst X Y) y = 1 :=
begin
  refine Hhomotopy H n (pconst_pcompose (pconst X (plift punit)))⁻¹* y ⬝ _,
  refine Hcompose H n _ _ y ⬝ _,
  refine ap (H ^→ n _) (@eq_of_is_contr _ (Hlift_empty H n) _ 1) ⬝ _,
  apply respect_one
end

-- definition Hwedge (H : cohomology_theory) (n : ℤ) (A B : Type*) : H n (A ∨ B) ≃g H n A ×ag H n B :=
-- begin
--   refine Hiso H n (wedge_pequiv_fwedge A B)⁻¹ᵉ* ⬝g _,
--   refine Hadditive_equiv H n _ _ ⬝g _
-- end

definition cohomology_theory_spectrum.{u} [constructor] (Y : spectrum.{u}) : cohomology_theory.{u} :=
cohomology_theory.mk
  (λn A, H^n[A, Y])
  (λn A B f, cohomology_isomorphism f Y n)
  (λn A, cohomology_isomorphism_refl A Y n)
  (λn A B f, cohomology_functor f Y n)
  (λn A B f g p, cohomology_functor_phomotopy p Y n)
  (λn A B f x, cohomology_functor_phomotopy_refl f Y n x)
  (λn A x, cohomology_functor_pid A Y n x)
  (λn A B C g f x, cohomology_functor_pcompose g f Y n x)
  (λn A, cohomology_susp A Y n)
  (λn A B f, cohomology_susp_natural f Y n)
  (λn A B f, cohomology_exact f Y n)
  (λn I A H, spectrum_additive H A Y n)

-- set_option pp.universes true
-- set_option pp.abbreviations false
-- print cohomology_theory_spectrum
-- print EM_spectrum
-- print has_choice_lift
-- print equiv_lift
-- print has_choice_equiv_closed
definition ordinary_cohomology_theory_EM [constructor] (G : AbGroup) : ordinary_cohomology_theory :=
⦃ordinary_cohomology_theory, cohomology_theory_spectrum (EM_spectrum G), Hdimension := EM_dimension G ⦄

end cohomology
