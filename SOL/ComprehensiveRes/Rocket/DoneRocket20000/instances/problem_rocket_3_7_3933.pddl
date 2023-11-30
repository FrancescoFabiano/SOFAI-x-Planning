; Optimality lenght is (:optlen 60)
; Solution is (:solution fuelup r0 l3,load c2 r0 l3,fly r0 l3 l0,unload c2 r0 l0,fuelup r0 l0,load c10 r0 l0,fly r0 l0 l6,unload c10 r0 l6,fuelup r0 l6,load c13 r0 l6,fly r0 l6 l1,unload c13 r0 l1,fuelup r0 l1,load c1 r0 l1,fly r0 l1 l2,unload c1 r0 l2,fuelup r0 l2,load c6 r0 l2,fly r0 l2 l5,unload c6 r0 l5,fuelup r0 l5,load c12 r0 l5,fly r0 l5 l3,unload c12 r0 l3,fuelup r0 l3,load c8 r0 l3,fly r0 l3 l4,unload c8 r0 l4,fuelup r1 l1,load c3 r1 l1,fly r1 l1 l2,unload c3 r1 l2,fuelup r1 l2,load c18 r1 l2,fly r1 l2 l6,unload c18 r1 l6,fuelup r1 l6,load c11 r1 l6,fly r1 l6 l1,unload c11 r1 l1,fuelup r2 l4,load c16 r2 l4,fly r2 l4 l5,unload c16 r2 l5,fuelup r2 l5,load c7 r2 l5,fly r2 l5 l6,unload c7 r2 l6,fuelup r2 l6,load c20 r2 l6,fly r2 l6 l0,unload c20 r2 l0,fuelup r2 l0,load c15 r2 l0,fly r2 l0 l4,unload c15 r2 l4,fuelup r2 l4,load c17 r2 l4,fly r2 l4 l3,unload c17 r2 l3)
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
	(at r0 l3) (at r1 l1) (at r2 l4)
	
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
	(at c18 l2) (at c2 l3) (at c10 l0)
	(at c3 l1) (at c16 l4) (at c11 l6)
	(at c7 l5) (at c13 l6) (at c1 l1)
	(at c17 l4) (at c15 l0) (at c6 l2)
	(at c9 l5) (at c0 l3) (at c8 l3)
	(at c19 l4) (at c20 l6) (at c14 l2)
	(at c4 l0) (at c12 l5) (at c5 l1)
	  )
  (:goal (and 
	(at c9 l5) (at c5 l1) (at c20 l0)
	(at c19 l4) (at c7 l6) (at c0 l3)
	(at c3 l2) (at c6 l5) (at c12 l3)
	(at c8 l4) (at c14 l2) (at c4 l0)
	(at c13 l1) (at c10 l6) (at c18 l6)
	(at c17 l3) (at c11 l1) (at c1 l2)
	(at c16 l5) (at c15 l4) (at c2 l0)
	  )
  )
)
