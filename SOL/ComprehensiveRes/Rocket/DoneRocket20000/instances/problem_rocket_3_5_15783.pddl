; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l1,load c6 r0 l1,fly r0 l1 l0,unload c6 r0 l0,fuelup r0 l0,load c2 r0 l0,fly r0 l0 l2,unload c2 r0 l2,fuelup r0 l2,load c10 r0 l2,fly r0 l2 l4,unload c10 r0 l4,fuelup r0 l4,load c12 r0 l4,fly r0 l4 l3,unload c12 r0 l3,fuelup r0 l3,load c8 r0 l3,fly r0 l3 l1,unload c8 r0 l1,fuelup r1 l1,load c9 r1 l1,fly r1 l1 l0,unload c9 r1 l0,fuelup r1 l0,load c3 r1 l0,fly r1 l0 l3,unload c3 r1 l3,fuelup r1 l3,load c4 r1 l3,fly r1 l3 l4,unload c4 r1 l4,fuelup r1 l4,load c7 r1 l4,fly r1 l4 l2,unload c7 r1 l2,fuelup r1 l2,load c1 r1 l2,fly r1 l2 l1,unload c1 r1 l1,fuelup r2 l1,load c14 r2 l1,fly r2 l1 l2,unload c14 r2 l2,fuelup r2 l2,load c11 r2 l2,fly r2 l2 l4,unload c11 r2 l4,fuelup r2 l4,load c0 r2 l4,fly r2 l4 l0,unload c0 r2 l0,fuelup r2 l0,load c5 r2 l0,fly r2 l0 l1,unload c5 r2 l1)
(define (problem rocket_3_15_5)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	c6 c7 c8
	c9 c10 c11
	c12 c13 c14
	l0 l1 l2
	l3 l4   )
  (:init
	(at r0 l1) (at r1 l1) (at r2 l1)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) 
	(at c11 l2) (at c14 l1) (at c4 l3)
	(at c12 l4) (at c5 l0) (at c10 l2)
	(at c3 l0) (at c7 l4) (at c6 l1)
	(at c13 l3) (at c8 l3) (at c0 l4)
	(at c1 l2) (at c9 l1) (at c2 l0)
	  )
  (:goal (and 
	(at c1 l1) (at c12 l3) (at c0 l0)
	(at c14 l2) (at c10 l4) (at c7 l2)
	(at c6 l0) (at c4 l4) (at c3 l3)
	(at c8 l1) (at c11 l4) (at c13 l3)
	(at c2 l2) (at c9 l0) (at c5 l1)
	  )
  )
)
