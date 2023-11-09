(define (problem rrt10)
  (:domain rockets)
  (:requirements :strips)
  (:objects l1 l2 l3 l4 l5 l6 l7 l8 l9 l10
			r1 r2 r3 r4 r5 r6 r7 r8 r9 r10
			c1 c2 c3 c4 c5 c6 c7 c8 c9 c10)
  (:init
   (location l1) (location l2) (location l3) (location l4) (location l5) (location l6) (location l7) (location l8) (location l9) (location l10)
   (rocket r1)   (rocket r2)   (rocket r3)   (rocket r4)   (rocket r5)   (rocket r6)   (rocket r7)   (rocket r8)   (rocket r9)   (rocket r10)
   (cargo c1)    (cargo c2)    (cargo c3)    (cargo c4)    (cargo c5)    (cargo c6)    (cargo c7)    (cargo c8)    (cargo c9)    (cargo c10)
   
   (at r1 l1) (at r2 l3) (at r3 l6)  (at r4 l7) (at r5 l8) (at r6 l9) (at r7 l4) (at r8 l5) (at r9 l10) (at r10 l2)
   (at c2 l1) (at c4 l3) (at c10 l6) (at c7 l7) (at c8 l8) (at c3 l9) (at c5 l4) (at c6 l5) (at c9 l10) (at c1 l2)
   (fuel r1) (fuel r2) (fuel r3) (fuel r4) (fuel r5) (fuel r6) (fuel r7) (fuel r8) (fuel r9) (fuel r10))
  
  (:goal (and (at c1 l1) (at c2 l3) (at c3 l6) (at c4 l7) (at c5 l8) (at c6 l9) (at c7 l4) (at c8 l5) (at c9 l2) (at c10 l10)
		 (at r2 l3) (at r3 l6)  (at r4 l7) (at r5 l8) (at r6 l9) (at r7 l4) (at r8 l5) (at r9 l10) (at r10 l2)
  ))
)
