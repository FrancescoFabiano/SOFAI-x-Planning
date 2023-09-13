; Optimality lenght is (:optlen 8)

(define (problem problem_4_3_2_92)
(:domain gripper-strips)
(:objects 
robot1 robot2 robot3 - robot
lgripper1 lgripper2 lgripper3 rgripper1 rgripper2 rgripper3 - gripper
room1 room2 - room
ball1 ball2 ball3 ball4 - object )

(:init
(at-robby robot1 room2)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room2)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at-robby robot3 room2)
(free robot3 lgripper3)
(free robot3 rgripper3)
(at ball1 room2)
(at ball2 room2)
(at ball3 room1)
(at ball4 room2)
)

(:goal (and
(at ball1 room1)
(at ball2 room2)
(at ball3 room2)
(at ball4 room1)
)
)
)

