; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l2,load c5 r0 l2,fly r0 l2 l3,unload c5 r0 l3,fuelup r0 l3,load c0 r0 l3,fly r0 l3 l1,unload c0 r0 l1,fuelup r0 l1,load c8 r0 l1,fly r0 l1 l5,unload c8 r0 l5,fuelup r0 l5,load c3 r0 l5,fly r0 l5 l2,unload c3 r0 l2,fuelup r0 l2,load c11 r0 l2,fly r0 l2 l4,unload c11 r0 l4,fuelup r1 l0,load c16 r1 l0,fly r1 l0 l4,unload c16 r1 l4,fuelup r1 l4,load c7 r1 l4,fly r1 l4 l2,unload c7 r1 l2,fuelup r1 l2,load c15 r1 l2,fly r1 l2 l1,unload c15 r1 l1,fuelup r1 l1,load c14 r1 l1,fly r1 l1 l0,unload c14 r1 l0,fuelup r2 l4,load c13 r2 l4,fly r2 l4 l1,unload c13 r2 l1,fuelup r2 l1,load c17 r2 l1,fly r2 l1 l5,unload c17 r2 l5,fuelup r2 l5,load c6 r2 l5,fly r2 l5 l2,unload c6 r2 l2)
(define (problem rocket_3_18_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	c6 c7 c8
	c9 c10 c11
	c12 c13 c14
	c15 c16 c17
	l0 l1 l2
	l3 l4 l5
	  )
  (:init
	(at r0 l2) (at r1 l0) (at r2 l4)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) (location l5)
	
	(at c8 l1) (at c2 l3) (at c5 l2)
	(at c10 l0) (at c4 l5) (at c13 l4)
	(at c15 l2) (at c1 l4) (at c6 l5)
	(at c17 l1) (at c12 l3) (at c9 l0)
	(at c16 l0) (at c14 l1) (at c0 l3)
	(at c3 l5) (at c11 l2) (at c7 l4)
	  )
  (:goal (and 
	(at c12 l3) (at c0 l1) (at c17 l5)
	(at c14 l0) (at c3 l2) (at c16 l4)
	(at c6 l2) (at c4 l5) (at c11 l4)
	(at c2 l3) (at c9 l0) (at c15 l1)
	(at c13 l1) (at c7 l2) (at c8 l5)
	(at c5 l3) (at c10 l0) (at c1 l4)
	  )
  )
)
