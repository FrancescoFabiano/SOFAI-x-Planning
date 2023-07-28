(define (problem problem_2_4_4_45)
(:domain driverlog)
(:objects 
driver1 driver2 - driver 
truck1 truck2 truck3 truck4 - truck 
package1 package2 package3 package4 - obj 
s1 s2 s3 s4 - location 
 )

(:init
(at driver1 s2)
(at driver2 s3)
(at truck1 s3)
(empty truck1)
(at truck2 s4)
(empty truck2)
(at truck3 s1)
(empty truck3)
(at truck4 s2)
(empty truck4)
(link s1 s2)
(link s2 s1)
(link s1 s4)
(link s4 s1)
(link s2 s4)
(link s4 s2)
(link s3 s1)
(link s1 s3)
(link s3 s2)
(link s2 s3)
(link s4 s3)
(link s3 s4)
(at package1 s3)
(at package2 s3)
(at package3 s3)
(at package4 s4)
)

(:goal (and
(at package1 s4)
(at package2 s1)
(at package3 s3)
(at package4 s4)
)
)
)
