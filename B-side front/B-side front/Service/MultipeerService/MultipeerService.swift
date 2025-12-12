//
//  MultipeerService.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import Foundation
import MultipeerConnectivity

@Observable
final class MultipeerService: NSObject {
    //identifiant appareil dans le reseau
    let peerID: MCPeerID
    //canal de communication
    let session: MCSession
    //Seulement si Host -> Annonce la partie
    var advertiser: MCNearbyServiceAdvertiser?
    //Seulement si client -> scanne les appareil dispo et se connecte
    var browser: MCNearbyServiceBrowser?
    
    private let serviceType = "mpc-blind-test"


    //init avec nom du joueur
    init(displayName: String) {
        self.peerID = MCPeerID(displayName: displayName)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    }

    
    func startHosting() {
        advertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }


    func joinSession() {
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    func send(message: String) {
        guard !session.connectedPeers.isEmpty else { return }
        
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Erreur envoi message : \(error.localizedDescription)")
            }
        }
    }

}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {

        // accepter la connexion
        invitationHandler(true, session)
    }
}

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // on envoie automatiquement l'invitation au peer trouvé
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Ici on pourrait gérer si un peer disparaît du réseau
        print("Peer perdu : \(peerID.displayName)")
    }
}

extension MultipeerService: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Peer \(peerID.displayName) a changé d'état : \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // On convertit les données en String
        if let message = String(data: data, encoding: .utf8) {
            // Ici, tu pourrais mettre à jour ton ViewModel
            print("Message reçu de \(peerID.displayName) : \(message)")
        }
    }
    
    // Les autres méthodes requises mais inutilisées ici
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

