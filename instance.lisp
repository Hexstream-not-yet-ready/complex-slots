(in-package #:complex-slots)

(defclass complex-slots:standard-complex-slots-object (complex-slots:instance-concrete-slots-storage-mixin c2mop:standard-object)
  ())

(defgeneric complex-slots:concrete-slot-using-class (class object slot-definition)
  (:method ((class complex-slots:complex-slots-class) object (slotd complex-slots:standard-effective-complex-slot-definition))
    (slot-value (ecase (c2mop:slot-definition-allocation slotd)
                  (complex-slots:instance-allocation (complex-slots:instance-concrete-slots-storage object))
                  (complex-slots:class-allocation (complex-slots:class-concrete-slots-storage class)))
                (c2mop:slot-definition-name slotd))))

(defmethod c2mop:slot-boundp-using-class ((class complex-slots:complex-slots-class) object (slotd complex-slots:standard-effective-complex-slot-definition))
  (eq (complex-slots:value (complex-slots:concrete-slot-using-class class object slotd))
      complex-slots:+unbound+))

(defmethod c2mop:slot-value-using-class ((class complex-slots:complex-slots-class) object (slotd complex-slots:standard-effective-complex-slot-definition))
  (let ((value (complex-slots:value (complex-slots:concrete-slot-using-class class object slotd))))
    (if (eq value complex-slots:+unbound+)
        (slot-unbound class object (c2mop:slot-definition-name slotd))
        value)))

(defmethod (setf c2mop:slot-value-using-class) (new-value (class complex-slots:complex-slots-class) object (slotd complex-slots:standard-effective-complex-slot-definition))
  (setf (complex-slots:value (complex-slots:concrete-slot-using-class class object slotd)) new-value))

(defmethod c2mop:slot-makunbound-using-class ((class complex-slots:complex-slots-class) object (slotd complex-slots:standard-effective-complex-slot-definition))
  (setf (complex-slots:value (complex-slots:concrete-slot-using-class class object slotd))
        complex-slots:+unbound+))
