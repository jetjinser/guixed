(use-modules (avahi)
             (avahi client)
             (avahi client publish)
             (ice-9 threads)
             (ice-9 match))

(define (group-callback group state)
  (match state
    (entry-group-state/established
     (format #t "Service is now published!~%"))
    (entry-group-state/collision
     (format #t "Service name collision detected!~%"))
    (entry-group-state/failure
     (format #t "Failed to publish service!~%"))
    (entry-group-state/registering
     (format #t "Registering service!~%"))
    (entry-group-state/uncommited
     (format #t "Group uncommited!~%"))))

(define client-callback
  (let ((group #f))
    (lambda (client state)
      (if (eq? state client-state/s-running)
          (begin
            ;; The client is now running so we can create an entry
            ;; group and publish a service.
            (set! group (make-entry-group client group-callback))
            (add-entry-group-address! group interface/unspecified
                                      protocol/unspecified (list publish-flag/no-reverse)
                                      "torrent.cosette.local"
                                      protocol/inet
                                      (inet-makeaddr (logior (ash 192 24) (ash 168 16) (ash 1 8)) 3))
            (add-entry-group-service! group interface/unspecified
                                      protocol/unspecified '()
                                      "transmission"
                                      "_http._tcp"
                                      #f "torrent.cosette.local"
                                      9001)
            ;; Commit the entry group, i.e., actually publish
            ;; the service.
            (commit-entry-group group))))))

(let* [(poll (make-simple-poll))
       (client (make-client (simple-poll poll)
                            '() ;; no flags
                            client-callback))]
  (if (not (client? client))
      (begin
        (format #t "Failed to create Avahi client!~%")
        (exit 1)))

  (run-simple-poll poll))
