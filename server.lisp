(defpackage :bitcloud
  (:use :cl :cl-who :hunchentoot :parenscript))

(in-package :bitcloud)


(defclass worker ()
  (alias
   private-key
   public-key
   banned?
   banned-time
   protected?))

(defclass user (worker)
  (votes
   wallet
   favorites
   moderators
   history
   updloads))

(defclass stream ()
  (nodes
   contents))

(defclass content ()
  (name
   description
   owner
   owner-signature
   release-date
   expiration-date
   tags ; categories
   files
   mimetype
   puntuations
   comments
   link
   min-speed-requirement
   updates))

(defclass file ()
  (version
   version-description
   data
   hash
   owner-signature))

(defclass moderator (worker)
  (contents
   trusted-users
   supermoderators
   advertisers
   ads-price
   ads-share-to-users
   tags))

(defclass moderated-content ()
  (content
   rename
   retags))


(defclass wallet ()
  (worker
   balance
   transactions))

(defclass transaction ()
  (hash
   date
   confirmations
   sender
   reciever
   sender-signature
   amount
   (escrow nil)
   (escrow-expiration-date nil)
   (escrow-origin-coin-type nil)
   (escrow-origin-coin-address nil)))

(defclass block ()
  (transactions
   worker-bans))

(defvar *current-pool* nil)
(defvar *last-pool* nil)
(defvar *new-pool-time* 600)
(defvar *current-block* nil)
(defvar *blockchain* '())
(defconstant *new-block-time* 600) ;seconds

(defgeneric create-user (credentials))
(defgeneric submit (thing))

(defgeneric sign (thing key))

;agent generics  -- proof of work

(defclass node (worker)
  (max-download-speed
   max-upload-speed
   max-space
   signature
   accepted-coins
   moderators
   preferential-moderators
   cloud-moderators
   protected?
   shutdown-date))

(defclass pool ()
  (nodes))


(defclass file-cache ()
  (path
   file
   insert-date
   expiration
   partial-views-count
   complete-views-count))

(defclass cache ()
  (max-size
   files))

(defgeneric ban (worker))

(defun check-pool (pool)
  (let ((nodes (select-pseudorandom (nodes p))))
    (mapcan #'ban
	    (;check real serving bandwidth
	     ;check agent working
	     ;check nodes assigments
	     ;check content correctness in serving
	     ;check users correctness
	     ;check short circuit
	     ))
    (submit pool)))

; blockchain

(defun generate-primordial-block ())
(defun generate-first-pool ())


;;;;;;;;; p2p protocol

(defclass node-stats ()
  (node
   speed-load
   node-connections
   user-connections
   moderator-connections
   cache
   space-load
   hunchentoot-accepter))

(defclass connection ()
  (worker
   worker-signature
   node-signature
   origin-ip
   exit-ip
   start-date
   expiration-date
   protected?
   last-command
   last-command-date
   last-error
   last-error-date))

(defgeneric connect (from to)) ; => connection
(defun start-node-server-daemon (node)) ; => node-stats

(defmacro irm (connection &body body))  ;; query interpreter
(defun order (connection commands))
(defun run (connection commands))

;routing

(defun select-pseudorandom-nodes (pool &key (amount 8)))

(defclass stream-block ()
  (size
   hash))

(defconstant +how-many-nodes+ 3)
(defun request-nodes (node &key (amount +how-many-nodes+))) ; => entry node
(defun request-protected-circuit (node &key (amount +how-many-nodes+))) ; => entry node
(defun request-node-stats (pool node))


;money transactions

(defgeneric check-coin-daemon (wallet))
(defgeneric launch-coin-daemon (wallet))
(defgeneric send-money (transaction))
(defgeneric exchange-to-foreign-coin (transaction foreign-wallet))
(defgeneric exchange-from-foreign-coin (transaction foreign-wallet))


;interface

(defgeneric log (worker message))
(defun launch-interface (output))
(defun console (node))


;proof of stake

(defgeneric judge-time (worker connection))
(defgeneric judge-bandwidth (worker connection))
(defgeneric judge-storage (worker connection))
(defgeneric judge-moderation (worker connection))
(defgeneric judge-transactions (worker connection))



(defun apply-rules-to-node (node)
  (proof-of-bandwidth node)
  (proof-of-storage node)
  (proof-of-moderation node)
  (proof-of-transactions node))


(defmethod judge-bandwidth ((node NODE) connection))
(defmethod judge-bandwidth ((moderator MODERATOR) connection))
(defmethod judge-bandwidth ((user USER) connection))


(verdict :law 'bandwidth :correct t :reward 0.2345 :beneficiary a-worker)
(verdict :law 'storage :correct nil :penalization 1.3 :victim a-worker :ban 6)


(defmacro with-laws-enforce-to (node &body judments))

(with-laws-enforce-to worker
  judge-bandwidth
  judge-storage
  ...)

(defgeneric enforce (worker verdict))
(defmethod enforce ((node NODE) verdict))


(defun request-time (node))

(defgeneric judge-timestamps (node connection))
