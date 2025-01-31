;; EcoToken Contract
(define-fungible-token eco-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))

;; Data structures
(define-map projects 
  { project-id: uint }
  {
    owner: principal,
    name: (string-ascii 64),
    description: (string-ascii 256),
    verified: bool,
    carbon-credits: uint
  }
)

(define-map verifiers principal bool)

;; Data vars
(define-data-var next-project-id uint u1)

;; Add verifier
(define-public (add-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set verifiers verifier true))))

;; Register project
(define-public (register-project (name (string-ascii 64)) (description (string-ascii 256)))
  (let ((project-id (var-get next-project-id)))
    (map-set projects 
      { project-id: project-id }
      {
        owner: tx-sender,
        name: name,
        description: description,
        verified: false,
        carbon-credits: u0
      }
    )
    (var-set next-project-id (+ project-id u1))
    (ok project-id)))

;; Verify project
(define-public (verify-project (project-id uint))
  (let ((is-verifier (default-to false (map-get? verifiers tx-sender))))
    (asserts! is-verifier err-unauthorized)
    (match (map-get? projects {project-id: project-id})
      project (ok (map-set projects 
        {project-id: project-id}
        (merge project {verified: true})))
      err-not-found)))

;; Add carbon credits
(define-public (add-carbon-credits (project-id uint) (amount uint))
  (let (
    (is-verifier (default-to false (map-get? verifiers tx-sender)))
    (project (unwrap! (map-get? projects {project-id: project-id}) err-not-found))
  )
    (asserts! is-verifier err-unauthorized)
    (asserts! (get verified project) err-unauthorized)
    (map-set projects
      {project-id: project-id}
      (merge project {carbon-credits: (+ (get carbon-credits project) amount)}))
    (ft-mint? eco-token amount (get owner project))))

;; Transfer tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? eco-token amount sender recipient))

;; Read only functions
(define-read-only (get-project (project-id uint))
  (map-get? projects {project-id: project-id}))

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance eco-token account)))
