; Optimality lenght is (:optlen 4)

(define (problem problem_3_2_5_110)
(:domain gripper-strips)
(:objects 
robot1 robot2 - robot
lgripper1 lgripper2 rgripper1 rgripper2 - gripper
room1 room2 room3 room4 room5 - room
ball1 ball2 ball3 - object )

(:init
(at-robby robot1 room3)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room2)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at ball1 room5)
(at ball2 room2)
(at ball3 room4)
)

(:goal (and
(at ball1 room5)
(at ball2 room2)
(at ball3 room3)
)
)
)

