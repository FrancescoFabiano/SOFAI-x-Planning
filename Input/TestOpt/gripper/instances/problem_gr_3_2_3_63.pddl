; Optimality lenght is (:optlen 6)

(define (problem problem_3_3_2_63)
(:domain gripper-strips)
(:objects 
robot1 robot2 robot3 - robot
lgripper1 lgripper2 lgripper3 rgripper1 rgripper2 rgripper3 - gripper
room1 room2 - room
ball1 ball2 ball3 - object )

(:init
(at-robby robot1 room1)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room1)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at-robby robot3 room1)
(free robot3 lgripper3)
(free robot3 rgripper3)
(at ball1 room2)
(at ball2 room2)
(at ball3 room1)
)

(:goal (and
(at ball1 room1)
(at ball2 room2)
(at ball3 room2)
)
)
)

