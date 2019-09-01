(asdf:defsystem #:complex-slots

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  ;; See the UNLICENSE file for details.
  :license "Unlicense"

  :description "Provides a new slot allocation type whose instances are represented as an arbitrary object."

  :depends-on ("closer-mop"
               "cesdi")

  :version "0.1"
  :serial cl:t
  :components ((:file "package")
               (:file "concrete-slots")
               (:file "class")
               (:file "instance"))

  :in-order-to ((asdf:test-op (asdf:test-op #:complex-slots_tests))))
