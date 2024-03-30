#import "pf2.typ": *

Hello world

#blk[
    + Hello world <l1>
    + Foobar
        + Next level
    + Previous level
        + Foobar
        + Next level <l2>
        + Sibling
    + Previous level by #refer(<l2>)
        + Previous level <l3>
            + Foobar @l1
            + Next level
        + Previous level
        + Previous level @l3
            + Previous level
                + Foobar
                + Next level @l3
            + Previous level
                + Parent 1 #parent(1)
                + Parent 2 #parent(2)
                + Parent 3 #parent(3)
]

#line()

#blk[
    + $2 = 8\/4$ <r0> \
      #pf By Thm. 1.2
    + $8 = 2 sqrt(16)$
        + $8 = 4 + 4$ <r2> \
          #pf Obvious.
        + $4 = sqrt(16)$
            + $4 . 4 = 16$ \
              #pf Step @r2
            + #qed \
              #pf By #prev(1)
        + #qed \
          #pf #prev(1) and @r0
    + #qed \
      #pf By #prev(1)
]

#line()

#blk[
    + #assume[There is a smallest purple number $n$.] <y1>
      #prove[$n+1$ is puce.]
        + #suffices[There is a smallest purple number $n$.]
    + #suffices[
        #assume[$n > 0$ by @y1]
        #prove[$n + 1 > 1$]
      ]
        + #case[There is no smallest purple number.]
    + #pflet[Let $n$ be the smallest purple number.]
        + #pflet[$n = 2 sqrt(y)$ \ $m = n + 1$]
    + #def[$n = 2 sqrt(y)$ \ $m = n + 1$]
]

#line()

#blk[
    + #suffices[
        #assume[There is a smallest purple number $n$.]
        #prove[$n+1$ is puce.]
    ]
]

#line()

// Nested

#prove[$n in bb(N) => n = 3$]

+ Three proof blocks below
    + #blk[
        + #suffices[$n >= 0$, $n + 3 = 6$]
        + #assume[$n >= 0$, $n + 3 = 6$]
        + #prove[$n >= 0$, $n + 3 = 6$]
    ]
    + Just two now
        + #blk[
            + #suffices[$n in bb(N)$]
                + #suffices[$n in bb(N)$]
                    + #suffices[$n in bb(N)$]
                    + #suffices[$n in bb(N)$]
                + #suffices[$n in bb(N)$]
        ]
        + #blk[
            + #suffices[$n in bb(N)$]
                + #suffices[$n in bb(N)$]
                    + #suffices[$n in bb(N)$]
                    + #suffices[$n in bb(N)$]
                + #suffices[$n in bb(N)$]
        ]
