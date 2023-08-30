(define (problem problem_3_4_5_55)
(:domain driverlog)
(:objects 
driver1 driver2 driver3 - driver 
truck1 truck2 truck3 truck4 - truck 
package1 package2 package3 package4 package5 - obj 
s1 s2 s3 s4 s5 - location 
 )

(:init
(at driver1 s2)
(at driver2 s4)
(at driver3 s1)
(at truck1 s1)
(empty truck1)
(at truck2 s3)
(empty truck2)
(at truck3 s5)
(empty truck3)
(at truck4 s1)
(empty truck4)
(link s1 s2)
(link s2 s1)
(link s2 s4)
(link s4 s2)
(link s2 s5)
(link s5 s2)
(link s3 s4)
(link s4 s3)
(link s5 s1)
(link s1 s5)
(link s5 s3)
(link s3 s5)
(at package1 s4)
(at package2 s3)
(at package3 s5)
(at package4 s1)
(at package5 s1)
)

(:goal (and
(at package1 s3)
(at package2 s2)
(at package3 s4)
(at package4 s5)
(at package5 s1)
)
)
)
