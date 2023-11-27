; Optimality lenght is (:optlen 60)
; Solution is (:solution fuelup r0 l2,load c18 r0 l2,fly r0 l2 l6,unload c18 r0 l6,fuelup r0 l6,load c2 r0 l6,fly r0 l6 l4,unload c2 r0 l4,fuelup r0 l4,load c9 r0 l4,fly r0 l4 l1,unload c9 r0 l1,fuelup r0 l1,load c12 r0 l1,fly r0 l1 l5,unload c12 r0 l5,fuelup r0 l5,load c17 r0 l5,fly r0 l5 l2,unload c17 r0 l2,fuelup r1 l0,load c5 r1 l0,fly r1 l0 l3,unload c5 r1 l3,fuelup r1 l3,load c16 r1 l3,fly r1 l3 l1,unload c16 r1 l1,fuelup r1 l1,load c0 r1 l1,fly r1 l1 l4,unload c0 r1 l4,fuelup r1 l4,load c10 r1 l4,fly r1 l4 l6,unload c10 r1 l6,fuelup r1 l6,load c7 r1 l6,fly r1 l6 l5,unload c7 r1 l5,fuelup r1 l5,load c20 r1 l5,fly r1 l5 l0,unload c20 r1 l0,fuelup r2 l3,load c1 r2 l3,fly r2 l3 l5,unload c1 r2 l5,fuelup r2 l5,load c4 r2 l5,fly r2 l5 l0,unload c4 r2 l0,fuelup r2 l0,load c11 r2 l0,fly r2 l0 l1,unload c11 r2 l1,fuelup r2 l1,load c13 r2 l1,fly r2 l1 l3,unload c13 r2 l3)
(define (problem rocket_3_21_7)
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
	c18 c19 c20
	l0 l1 l2
	l3 l4 l5
	l6   )
  (:init
	(at r0 l2) (at r1 l0) (at r2 l3)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17)
	(cargo c18) (cargo c19) (cargo c20)
	(location l0) (location l1) (location l2)
	(location l3) (location l4) (location l5)
	(location l6) 
	(at c17 l5) (at c16 l3) (at c8 l6)
	(at c11 l0) (at c10 l4) (at c13 l1)
	(at c14 l2) (at c19 l2) (at c15 l3)
	(at c0 l1) (at c4 l5) (at c5 l0)
	(at c3 l4) (at c2 l6) (at c12 l1)
	(at c9 l4) (at c1 l3) (at c6 l0)
	(at c7 l6) (at c20 l5) (at c18 l2)
	  )
  (:goal (and 
	(at c13 l3) (at c20 l0) (at c0 l4)
	(at c18 l6) (at c11 l1) (at c19 l2)
	(at c12 l5) (at c9 l1) (at c3 l4)
	(at c5 l3) (at c6 l0) (at c7 l5)
	(at c8 l6) (at c17 l2) (at c15 l3)
	(at c2 l4) (at c4 l0) (at c1 l5)
	(at c16 l1) (at c14 l2) (at c10 l6)
	  )
  )
)
