; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l2,load c3 r0 l2,fly r0 l2 l0,unload c3 r0 l0,fuelup r0 l0,load c6 r0 l0,fly r0 l0 l1,unload c6 r0 l1,fuelup r0 l1,load c13 r0 l1,fly r0 l1 l4,unload c13 r0 l4,fuelup r0 l4,load c7 r0 l4,fly r0 l4 l3,unload c7 r0 l3,fuelup r0 l3,load c1 r0 l3,fly r0 l3 l2,unload c1 r0 l2,fuelup r1 l2,load c4 r1 l2,fly r1 l2 l4,unload c4 r1 l4,fuelup r1 l4,load c14 r1 l4,fly r1 l4 l3,unload c14 r1 l3,fuelup r1 l3,load c11 r1 l3,fly r1 l3 l0,unload c11 r1 l0,fuelup r1 l0,load c12 r1 l0,fly r1 l0 l2,unload c12 r1 l2,fuelup r2 l0,load c10 r2 l0,fly r2 l0 l4,unload c10 r2 l4,fuelup r2 l4,load c8 r2 l4,fly r2 l4 l1,unload c8 r2 l1,fuelup r2 l1,load c9 r2 l1,fly r2 l1 l0,unload c9 r2 l0)
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
	(at r0 l2) (at r1 l2) (at r2 l0)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) 
	(at c4 l2) (at c12 l0) (at c9 l1)
	(at c1 l3) (at c14 l4) (at c10 l0)
	(at c3 l2) (at c2 l3) (at c5 l1)
	(at c8 l4) (at c6 l0) (at c11 l3)
	(at c7 l4) (at c13 l1) (at c0 l2)
	  )
  (:goal (and 
	(at c11 l0) (at c14 l3) (at c5 l1)
	(at c12 l2) (at c4 l4) (at c7 l3)
	(at c6 l1) (at c9 l0) (at c13 l4)
	(at c0 l2) (at c10 l4) (at c1 l2)
	(at c3 l0) (at c2 l3) (at c8 l1)
	  )
  )
)
