(asdf:defsystem layout
  :version "0.0.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "A text and glyph layouting system"
  :homepage "https://shirakumo.github.io/layout/"
  :bug-tracker "https://github.com/shirakumo/layout/issues"
  :source-control (:git "https://github.com/shirakumo/layout.git")
  :serial T
  :components ((:file "package")
               (:file "documentation"))
  :depends-on (:documentation-utils
               :uax-14
               :uax-9)
  :in-order-to ((asdf:test-op (asdf:test-op :layout/test))))

(asdf:defsystem layout/test
  :version "1.0.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "Tests for the layout system."
  :homepage "https://shirakumo.github.io/layout/"
  :bug-tracker "https://github.com/shirakumo/layout/issues"
  :source-control (:git "https://github.com/shirakumo/layout.git")
  :serial T
  :components ((:file "test"))
  :depends-on (:layout :parachute)
  :perform (asdf:test-op (op c) (uiop:symbol-call :parachute :test :org.shirakumo.layout.test)))
