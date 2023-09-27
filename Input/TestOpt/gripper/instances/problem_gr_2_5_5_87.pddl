; Optimality lenght is (:optlen 14)

(define (problem problem_5_2_5_87)
(:domain gripper-strips)
(:objects 
robot1 robot2 - robot
lgripper1 lgripper2 rgripper1 rgripper2 - gripper
room1 room2 room3 room4 room5 - room
ball1 ball2 ball3 ball4 ball5 - object )

(:init
(at-robby robot1 room4)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room3)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at ball1 room5)
(at ball2 room4)
(at ball3 room5)
(at ball4 room5)
(at ball5 room4)
)

(:goal (and
(at ball1 room4)
(at ball2 room3)
(at ball3 room1)
(at ball4 room2)
(at ball5 room4)
)
)
)
