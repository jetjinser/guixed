(define-module (config services extra)
  #:use-module (sxml simple)
  #:use-module (srfi srfi-1)
  #:use-module (gnu services)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:export (avahi-service
            avahi-static-service-type))


;; avahi.service

;; Record type definition for Avahi services
(define-record-type* <avahi-service>
  avahi-service make-avahi-service
  avahi-service?
  (name        avahi-service-name)         ; string
  (type        avahi-service-type)         ; string (e.g., "_http._tcp")
  (port        avahi-service-port)         ; integer
  (txt-records avahi-service-txt-records   ; list of strings
               (default '())))

(define (avahi-service->sxml service)
  "Convert an <avahi-service> record to SXML."
  (match-record service <avahi-service>
    (name type port txt-records)
    `(service-group
       (name (@ (replace-wildcards "yes"))
             ,name)
       (service
         (type ,type)
         (port ,(number->string port))
         ,@(if (null? txt-records)
               '()
               (map (λ (txt) `(txt-record ,txt)) txt-records))))))

(define (sxml->avahi-service-file sxml)
  "Convert SXML to Avahi service file content."
  (with-output-to-string
    (λ ()
      (display "<?xml version=\"1.0\" standalone='no'?><!--*-nxml-*-->\n")
      (display "<!DOCTYPE service-group SYSTEM \"avahi-service.dtd\">\n")
      (sxml->xml sxml))))

(define (avahi-service-file name sxml)
  "Create a file-like object containing the SXML-generated Avahi service."
  (computed-file
    name
    #~(begin
        (use-modules (sxml simple))
        (call-with-output-file #$output
          (lambda (port)
            (display #$(sxml->avahi-service-file sxml) port))))))

(define avahi-static-service-type
  (let [(avahi-etc-service
         (λ (services)
           `(("avahi/services"
              ,(file-union "avahi-services-dir"
                           (map (λ (svc)
                                   (let [(filename (string-append (car svc) ".service"))
                                         (svc-struct (cadr svc))]
                                     (list filename
                                           (avahi-service-file
                                             filename
                                             (avahi-service->sxml svc-struct)))))
                                services))))))]
    (service-type
     (name 'avahi-static-service)
     (extensions
       (list (service-extension etc-service-type
                                avahi-etc-service)))
     (compose concatenate)
     (extend append)
     (default-value '())
     (description "Populate /etc/avahi/services with SXML-defined services."))))
