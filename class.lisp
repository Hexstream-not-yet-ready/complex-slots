(in-package #:complex-slots)

(defclass complex-slots:complex-and-simple-slots-mixin ()
  ((%complex-slots :reader complex-slots:complex-slots
                   :type list)
   (%simple-slots :reader complex-slots:simple-slots
                  :type list)))

(defmethod c2mop:finalize-inheritance :after ((mixin complex-slots:complex-and-simple-slots-mixin))
  (setf (values (slot-value mixin '%complex-slots)
                (slot-value mixin '%simple-slots))
        (let (complex-slots simple-slots)
          (dolist (effective-slot (c2mop:class-slots mixin))
            (if (typep effective-slot 'complex-slots:standard-effective-complex-slot-definition)
                (push effective-slot complex-slots)
                (push effective-slot simple-slots)))
          (values (nreverse complex-slots) (nreverse simple-slots)))))

(defclass complex-slots:standard-complex-slots-class (cesdi:cesdi-mixin complex-slots:complex-and-simple-slots-mixin complex-slots:class-concrete-slots-storage-mixin complex-slots:complex-slots-class)
  ())

(defclass complex-slots:standard-effective-complex-slot-definition (c2mop:standard-effective-slot-definition)
  ())

(defmethod cesdi:effective-slot-definition-class ((class complex-slots:standard-complex-slots-class) &key allocation &allow-other-keys)
  (if (complex-slots:complex-allocation-p class allocation)
      (find-class 'complex-slots:standard-effective-complex-slot-definition)
      (call-next-method)))
