;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pong) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; pong.rkt

;;===========
;; Constants:

(define WIDTH 800)
(define HEIGHT (* WIDTH (/ 2 3)))
(define MTS (empty-scene WIDTH HEIGHT))

(define BAR-W 30)
(define MAX-P (- WIDTH BAR-W))
(define BAR-IMG (rectangle BAR-W 10 "solid" "black"))

(define PLR-SPD 10)

(define BALL-S 5)
(define BALL-IMG (circle BALL-S "solid" "black"))

(define SCORE-BOX (rectangle 20 30 "outline" "black"))
(define DFLT-IMG (place-image SCORE-BOX (/ WIDTH 2) 10 MTS))

;;===========
;; Data defs:

;; Score is Natural
;; interp. the current player's score

(define S1 0)
(define S2 1)
(define S3 10)

#;
(define (fn-for-score s)
  (... s))

;; Player is Natural[0, (- WIDTH BAR-W)]
;; Interp. the current x-coord of the player paddle

(define P1 0)
(define P2 100)
(define P3 (- WIDTH BAR-W))

#;
(define (fn-for-player p)
  (... p))

(define-struct ball (x y angle))
;; Ball is (make-ball Natural Natural Natural[0, 360))
;; interp. a ball with an x, y coord and a current angle of travel

(define B1 (make-ball 0 0 200))
(define B2 (make-ball 100 100 100))
(define B3 (make-ball WIDTH HEIGHT 359))

#;
(define (fn-for-ball b)
  (... (ball-x b)
       (ball-y b)
       (ball-angle b)))

(define-struct world (score player ball))
;; World is (make-world Score Player Ball)
;; interp. a world-state

(define WS1 (make-world 0 0 B1))
(define WS2 (make-world 10 50 B2))
(define WS3 (make-world 10 P3 B3))

;;===========
;; Functions:

(define (main w)
  (big-bang w
            (on-tick update-world)       ;World -> World
            (to-draw render-world)       ;World -> Image
            (on-key handle-key)          ;World KeyEvent -> World
            (on-mouse reset-on-mouse)))  ;World MouseEvent -> World

;; World -> World
;; Updates the world state, by moving the ball and checking for collisions

(define (update-world ws) (make-world 0 0 B1)) ;stub


;; World -> Image
;; Renders the current world state

;; (define (render-world ws) DFLT-IMG) ;stub



;; World KeyEvent -> World
;; Forwards to move-paddle on arrow-press; ignores other keys for now

;; (define (handle-key ws ke) (make-world 0 0 B1)) ;stub
(check-expect (handle-key WS1 "right") (make-world 0 (+ PLR-SPD (world-player WS1)) B1))
(check-expect (handle-key WS1 "left") WS1)
(check-expect (handle-key WS3 "right") WS3)
(check-expect (handle-key WS2 "left") (make-world (world-score WS2) (- (world-player WS2) PLR-SPD) B2))
(check-expect (handle-key WS2 " ") WS2)

(define (handle-key ws ke)
  (cond [(or (key=? ke "right") (key=? ke "left")) (move-paddle ws ke)]
        [else ws]))

;; World KeyEvent -> World
;; Moves paddle, watching for collisions

(define (move-paddle ws ke)
  (cond [(key=? ke "left") (if (<= (- (world-player ws) PLR-SPD) 0)
                               (make-world (world-score ws) 0 (world-ball ws))
                               (make-world (world-score ws) (- (world-player ws) PLR-SPD) (world-ball ws)))]
        [else
         (if (>= (+ (world-player ws) PLR-SPD) MAX-P)
             (make-world (world-score ws) MAX-P (world-ball ws))
             (make-world (world-score ws) (+ (world-player ws) PLR-SPD) (world-ball ws)))]))



;; World MouseEvent -> World
;; Resets the game on mouse-click, ignores other mouse input

;; (define (reset-on-mouse ws x y me) (make-world 0 0 B1)) ;stub
(check-expect (reset-on-mouse WS1 0 0 "button-down") WS1)
(check-expect (reset-on-mouse WS2 10 10 "button-down") WS1)
(check-expect (reset-on-mouse WS3 10 10 "drag") WS3)

(define (reset-on-mouse ws x y me)
  (cond [(mouse=? me "button-down") WS1]
        [else ws]))