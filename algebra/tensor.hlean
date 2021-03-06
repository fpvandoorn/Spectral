/-
Copyright (c) 2015 Floris van Doorn. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Floris van Doorn, Egbert Rijke

Tensor group
-/

import .free_abelian_group

open eq algebra is_trunc sigma sigma.ops prod trunc function equiv
namespace group

  variables {G G' : Group} {g g' h h' k : G} {A B : AbGroup}

  /- Tensor group (WIP) -/

/-  namespace tensor_group
  variables {A B}
  local abbreviation ι := @free_ab_group_inclusion

  inductive tensor_rel_type : free_ab_group (Set_of_Group A ×t Set_of_Group B) → Type :=
  | mul_left  : Π(a₁ a₂ : A) (b : B), tensor_rel_type (ι (a₁, b)  * ι (a₂, b)  * (ι (a₁ * a₂, b))⁻¹)
  | mul_right : Π(a : A) (b₁ b₂ : B), tensor_rel_type (ι (a, b₁)  * ι (a, b₂)  * (ι (a, b₁ * b₂))⁻¹)

  open tensor_rel_type

  definition tensor_rel' (x : free_ab_group (Set_of_Group A ×t Set_of_Group B)) : Prop :=
  ∥ tensor_rel_type x ∥

  definition tensor_group_rel (A B : AbGroup)
    : normal_subgroup_rel (free_ab_group (Set_of_Group A ×t Set_of_Group B)) :=
  sorry /- relation generated by tensor_rel'-/

  definition tensor_group [constructor] : AbGroup :=
  quotient_ab_group (tensor_group_rel A B)

  end tensor_group-/

end group
