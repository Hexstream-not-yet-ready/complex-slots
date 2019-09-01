(in-package #:complex-slots)

(defclass complex-slots:complex-slots-class (c2mop:standard-class) ())

(defgeneric complex-slots:complex-allocation (class allocation)
  (:method :around (class allocation)
    (if (complex-slots:complex-allocation-p class allocation)
        allocation
        (call-next-method)))
  (:method ((class complex-slots:complex-slots-class) allocation)
    (ecase allocation
      (:instance 'complex-slots:instance-allocation)
      (:class 'complex-slots:class-allocation))))

(defgeneric complex-slots:complex-allocation-p (class allocation)
  (:method ((class complex-slots:complex-slots-class) allocation)
    (not (null (member allocation '(complex-slots:instance-allocation complex-slots:class-allocation) :test #'eq)))))


(defclass complex-slots:concrete-slots-storage () ())

(defgeneric complex-slots:ensure-concrete-slots-storage (concrete-slots-storage complex-slots-class &rest options &key)
  (:method (existing (class complex-slots:complex-slots-class) &rest options)
    (if existing
        (apply #'complex-slots:reinitialize-concrete-slots-storage existing class options)
        (apply #'complex-slots:compute-concrete-slots-storage class options))))

(defgeneric complex-slots:compute-concrete-slots-storage (complex-slots-class &rest options &key)
  (:method ((class complex-slots:complex-slots-class) &rest options)
    (let* ((initargs (apply #'complex-slots:compute-concrete-slots-storage-initargs class options)))
      (apply #'make-instance (apply #'complex-slots:compute-concrete-slots-storage-class class initargs)
             initargs))))

(defgeneric complex-slots:compute-concrete-slots-storage-initargs (complex-slots-class &rest options)
  (:method ((class complex-slots:complex-slots-class) &key allocation)
    (if (complex-slots:complex-allocation-p class allocation)
        (list :complex-slots (remove-if-not (lambda (slotd)
                                              (eq (c2mop:slot-definition-allocation slotd) allocation))
                                            (c2mop:class-slots class)))
        (error "~S is not a complex allocation type for ~S." allocation class))))

(defgeneric complex-slots:compute-concrete-slots-storage-class (complex-slots-class &rest initargs)
  (:method ((class complex-slots:complex-slots-class) &rest initargs)
    (apply #'make-instance 'standard-class
           (apply #'complex-slots:compute-concrete-slots-storage-class-initargs class initargs))))

(defgeneric complex-slots:compute-concrete-slots-storage-class-initargs (complex-slots-class &rest initargs)
  (:method ((class complex-slots:complex-slots-class) &rest initargs)
    (declare (ignore initargs))
    (list :name `(complex-slots:concrete-slots-storage ,(class-name class))
          :direct-superclasses (list (find-class 'complex-slots:concrete-slots-storage))
          :direct-slots nil)))

(defgeneric complex-slots:reinitialize-concrete-slots-storage (concrete-slots-storage complex-slots-class &rest initargs)
  (:method (existing (class complex-slots:complex-slots-class) &rest initargs)
    (prog1 existing
      (apply #'reinitialize-instance (class-of existing)
             (apply #'complex-slots:compute-concrete-slots-storage-class-initargs class initargs)))))

(defclass complex-slots:class-concrete-slots-storage-mixin (complex-slots:complex-slots-class)
  ((%class-concrete-slots-storage :reader complex-slots:class-concrete-slots-storage
                                  :type complex-slots:concrete-slots-storage
                                  :initform nil)))

(defmethod c2mop:finalize-inheritance :after ((complex-slots-class complex-slots:class-concrete-slots-storage-mixin))
  (setf (slot-value complex-slots-class '%class-concrete-slots-storage)
        (complex-slots:ensure-concrete-slots-storage (complex-slots:class-concrete-slots-storage complex-slots-class)
                                                     complex-slots-class
                                                     :allocation :class)))

(defclass complex-slots:instance-concrete-slots-storage-mixin ()
  ((%instance-concrete-slots-storage :reader complex-slots:instance-concrete-slots-storage
                                     :type complex-slots:concrete-slots-storage
                                     :initform nil)))


(defconstant complex-slots:+unbound+ 'complex-slots:+unbound+)

(defclass complex-slots:concrete-slot () ())

(defclass complex-slots:standard-concrete-slot (complex-slots:concrete-slot)
  ((%value :initarg :value
           :accessor complex-slots:value
           :initform complex-slots:+unbound+)))
