; Optimality lenght is (:optlen 13)

(define (problem problem_5_2_5_14)
(:domain gripper-strips)
(:objects 
robot1 robot2 - robot
lgripper1 lgripper2 rgripper1 rgripper2 - gripper
room1 room2 room3 room4 room5 - room
ball1 ball2 ball3 ball4 ball5 - object )

(:init
(at-robby robot1 room2)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room1)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at ball1 room5)
(at ball2 room3)
(at ball3 room5)
(at ball4 room5)
(at ball5 room3)
)

(:goal (and
(at ball1 room3)
(at ball2 room3)
(at ball3 room3)
(at ball4 room3)
(at ball5 room1)
)
)
)

