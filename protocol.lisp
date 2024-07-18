(in-package #:org.shirakumo.layout)

;; Users should subtype this to provide additional properties
(defstruct font
  ;; The font family name
  family
  ;; The weight of the font: NIL, :bold
  weight
  ;; The slanting property of the font: NIL, :italic
  slant
  ;; The normalized height of a line in pixels
  line-height)

;; Return a GLYPH instance for a specific codepoint (or NIL if not covered)
(defgeneric glyph (codepoint font))

;; Return a list of codepoint regions that the font covers (used for font chain computation)
(defgeneric codepoint-regions (font))

;; Returns the kerning to be applied between the codepoints A and B
(defgeneric kerning (a b font))

;; Users should subtype this to provide additional properties
(defstruct glyph
  ;; The codepoint of the glyph being represented
  codepoint
  ;; The font these properties belong to
  font
  ;; The normalized X offset of the glyph from the cursor in pixels
  xoff
  ;; The normalized Y offset of the glyph from the cursor in pixels
  yoff
  ;; The normalized width of the glyph in pixels
  width
  ;; The normalized height of the glyph in pixels
  height
  ;; The normalized distance the cursor should advance in X direction
  x-advance
  ;; ???: Diacritic info
  )

(defstruct font-chain
  ;; The primary font to use
  primary
  ;; The fallback glyph info to use if no specific one is found anywhere
  fallback)

;; Returns a GLYPH that best fits the given glyph (is never NIL)
(defgeneric glyph (codepoint font-chain))

;; Returns a FONT that best fits the given glyph (or NIL if not covered)
(defgeneric select-font (codepoint font-chain))

(defstruct layout
  ;; Whether line breaks should be inserted: NIL, T, :anywhere
  line-breaks
  ;; The default font size in pixels
  font-size
  ;; Whether multiple consecutive spacing characters should be contracted
  compress-spaces
  ;; The direction of glyphs within a line: :horizontal, :vertical
  line-direction
  ;; The origin of lines within the block: :top-left :top-right, :bottom-left, :bottom-right
  text-origin
  ;; How text lines should be aligned relative to the origin: :start, :middle, :end
  line-alignment
  ;; How the text block should be aligned relative to the origin: :start, :middle, :end
  block-alignment
  ;; How much vertical kerning to add between letters in pixels
  vertical-kerning
  ;; How much horizontal kerning to add between letters in pixels
  horizontal-kerning
  ;; How much spacing to add between letters in pixels
  glyph-spacing
  ;; How much spacing to add between words in pixels
  word-spacing
  ;; How much spacing to add between lines in pixels
  line-spacing)

(defclass layouter ()
  (;; The font chain to use
   font-chain
   ;; The layout parameters to use
   layout
   ;; The text to layout
   text
   ;; The list of markups for the text
   markup
   ;; The dimensions of the text box
   width height))

;; Computes a FONT-CHAIN based on the list of offered fonts, with optimised font selection
;; Earlier fonts in the sequence take precedence, allowing the user manual control
(defgeneric compute-font-chain (layouter fonts))

(defstruct markup
  ;; The index of the first character being marked up
  start
  ;; The bounding index with which characters are no longer marked up
  end)

(defmacro define-markup (name &rest properties)
  `(defstruct (,name (:include markup) (:copier NIL) (:predicate NIL)
                     (:constructor ,name (start end ,@properties)))
     ,@properties))

(define-markup bold)
(define-markup italic)
(define-markup monospace)
(define-markup size size)
(define-markup font font)

;; (lambda (glyph x y size markups) ...)
(defgeneric layout (layouter emitter))

;; (lambda (x y) ...)
(defgeneric cursor (layouter index emitter))

;; (lambda (x y w h) ...)
(defgeneric selection (layouter start end emitter))
