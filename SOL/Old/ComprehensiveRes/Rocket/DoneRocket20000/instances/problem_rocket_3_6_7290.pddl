; Optimality lenght is (:optlen 52)
; Solution is (:solution fuelup r0 l3,load c9 r0 l3,fly r0 l3 l1,unload c9 r0 l1,fuelup r0 l1,load c15 r0 l1,fly r0 l1 l5,unload c15 r0 l5,fuelup r0 l5,load c1 r0 l5,fly r0 l5 l0,unload c1 r0 l0,fuelup r0 l0,load c13 r0 l0,fly r0 l0 l2,unload c13 r0 l2,fuelup r0 l2,load c7 r0 l2,fly r0 l2 l3,unload c7 r0 l3,fuelup r1 l5,load c8 r1 l5,fly r1 l5 l3,unload c8 r1 l3,fuelup r1 l3,load c14 r1 l3,fly r1 l3 l0,unload c14 r1 l0,fuelup r1 l0,load c3 r1 l0,fly r1 l0 l2,unload c3 r1 l2,fuelup r1 l2,load c10 r1 l2,fly r1 l2 l4,unload c10 r1 l4,fuelup r1 l4,load c11 r1 l4,fly r1 l4 l1,unload c11 r1 l1,fuelup r2 l1,load c6 r2 l1,fly r2 l1 l3,unload c6 r2 l3,fuelup r2 l3,load c16 r2 l3,fly r2 l3 l2,unload c16 r2 l2,fuelup r2 l2,load c12 r2 l2,fly r2 l2 l5,unload c12 r2 l5)
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
	(at r0 l3) (at r1 l5) (at r2 l1)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) (location l5)
	
	(at c2 l4) (at c10 l2) (at c1 l5)
	(at c5 l0) (at c6 l1) (at c16 l3)
	(at c4 l4) (at c14 l3) (at c12 l2)
	(at c13 l0) (at c0 l5) (at c17 l1)
	(at c11 l4) (at c7 l2) (at c3 l0)
	(at c8 l5) (at c9 l3) (at c15 l1)
	  )
  (:goal (and 
	(at c13 l2) (at c12 l5) (at c9 l1)
	(at c2 l4) (at c7 l3) (at c5 l0)
	(at c17 l1) (at c1 l0) (at c4 l4)
	(at c8 l3) (at c3 l2) (at c0 l5)
	(at c11 l1) (at c14 l0) (at c16 l2)
	(at c15 l5) (at c10 l4) (at c6 l3)
	  )
  )
)
