; Optimality lenght is (:optlen 32)
; Solution is (:solution fuelup r0 l3,load c11 r0 l3,fly r0 l3 l4,unload c11 r0 l4,fuelup r0 l4,load c7 r0 l4,fly r0 l4 l1,unload c7 r0 l1,fuelup r0 l1,load c4 r0 l1,fly r0 l1 l2,unload c4 r0 l2,fuelup r0 l2,load c5 r0 l2,fly r0 l2 l0,unload c5 r0 l0,fuelup r0 l0,load c10 r0 l0,fly r0 l0 l3,unload c10 r0 l3,fuelup r1 l0,load c1 r1 l0,fly r1 l0 l5,unload c1 r1 l5,fuelup r1 l5,load c3 r1 l5,fly r1 l5 l1,unload c3 r1 l1,fuelup r1 l1,load c8 r1 l1,fly r1 l1 l0,unload c8 r1 l0)
(define (problem rocket_2_12_6)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	c10 c11
	l0 l1
	l2 l3
	l4 l5
	  )
  (:init
	(at r0 l3) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	
	(at c6 l2) (at c9 l3)
	(at c8 l1) (at c1 l0)
	(at c3 l5) (at c2 l4)
	(at c10 l0) (at c5 l2)
	(at c4 l1) (at c0 l5)
	(at c11 l3) (at c7 l4)
	  )
  (:goal (and 
	(at c5 l0) (at c4 l2)
	(at c0 l5) (at c3 l1)
	(at c10 l3) (at c2 l4)
	(at c9 l3) (at c7 l1)
	(at c1 l5) (at c6 l2)
	(at c8 l0) (at c11 l4)
	  )
  )
)
