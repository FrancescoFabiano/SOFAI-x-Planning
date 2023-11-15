; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l0,load c2 r0 l0,fly r0 l0 l2,unload c2 r0 l2,fuelup r0 l2,load c7 r0 l2,fly r0 l2 l3,unload c7 r0 l3,fuelup r0 l3,load c0 r0 l3,fly r0 l3 l4,unload c0 r0 l4,fuelup r0 l4,load c3 r0 l4,fly r0 l4 l1,unload c3 r0 l1,fuelup r0 l1,load c11 r0 l1,fly r0 l1 l6,unload c11 r0 l6,fuelup r0 l6,load c5 r0 l6,fly r0 l6 l0,unload c5 r0 l0,fuelup r1 l0,load c6 r1 l0,fly r1 l0 l6,unload c6 r1 l6,fuelup r1 l6,load c10 r1 l6,fly r1 l6 l1,unload c10 r1 l1,fuelup r1 l1,load c8 r1 l1,fly r1 l1 l4,unload c8 r1 l4,fuelup r1 l4,load c1 r1 l4,fly r1 l4 l2,unload c1 r1 l2,fuelup r1 l2,load c9 r1 l2,fly r1 l2 l5,unload c9 r1 l5,fuelup r1 l5,load c13 r1 l5,fly r1 l5 l0,unload c13 r1 l0)
(define (problem rocket_2_14_7)
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
	c12 c13
	l0 l1
	l2 l3
	l4 l5
	l6   )
  (:init
	(at r0 l0) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(cargo c12) (cargo c13)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) 
	(at c4 l5) (at c0 l3)
	(at c7 l2) (at c5 l6)
	(at c3 l4) (at c2 l0)
	(at c8 l1) (at c13 l5)
	(at c6 l0) (at c9 l2)
	(at c12 l3) (at c10 l6)
	(at c11 l1) (at c1 l4)
	  )
  (:goal (and 
	(at c8 l4) (at c3 l1)
	(at c12 l3) (at c5 l0)
	(at c2 l2) (at c9 l5)
	(at c6 l6) (at c13 l0)
	(at c10 l1) (at c7 l3)
	(at c0 l4) (at c4 l5)
	(at c11 l6) (at c1 l2)
	  )
  )
)
