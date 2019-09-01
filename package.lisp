(cl:defpackage #:complex-slots
  (:use #:cl)
  (:export #:instance-allocation
           #:class-allocation
           #:complex-allocation
           #:complex-allocation-p

           #:concrete-slots-storage
           #:ensure-concrete-slots-storage
           #:compute-concrete-slots-storage
           #:compute-concrete-slots-storage-initargs
           #:compute-concrete-slots-storage-class
           #:compute-concrete-slots-storage-class-initargs
           #:reinitialize-concrete-slots-storage

           #:concrete-slots-storage-mixin
           #:class-concrete-slots-storage-mixin
           #:class-concrete-slots-storage
           #:instance-concrete-slots-storage-mixin
           #:instance-concrete-slots-storage
           #:+unbound+
           #:concrete-slot
           #:standard-concrete-slot
           #:value

           #:complex-and-simple-slots-mixin
           #:complex-slots
           #:simple-slots
           #:complex-slots-class
           #:standard-complex-slots-class
           #:standard-effective-complex-slot-definition

           #:standard-complex-slots-object
           #:concrete-slot-using-class))
