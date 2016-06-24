#====================================================================
# FTAG5.py
# It requires the reductionConf flag FTAG5 in Reco_tf.py
#====================================================================

# Set up common services and job objects
# This should appear in ALL derivation job options
from DerivationFrameworkCore.DerivationFrameworkMaster import *
from DerivationFrameworkInDet.InDetCommon import *
from DerivationFrameworkJetEtMiss.JetCommon import *
from DerivationFrameworkJetEtMiss.ExtendedJetCommon import *
from DerivationFrameworkJetEtMiss.METCommon import *
from DerivationFrameworkEGamma.EGammaCommon import *
from DerivationFrameworkMuons.MuonsCommon import *

from AthenaCommon.AthenaCommonFlags import jobproperties as jp
jp.AthenaCommonFlags.EvtMax.set_Value_and_Lock(-1)

#===================================================================
# Variable R track jets
#===================================================================
from DerivationFrameworkExotics.JetDefinitions import *
from JetRec.JetRecStandard import jtm

FTAG5Seq = CfgMgr.AthSequencer("FTAG5Sequence")

jtm.modifiersMap["smallvr_track_modifiers"] = jtm.modifiersMap["pv0track"]
jtm.modifiersMap["largevr_track_modifiers"] = [jtm.ktsplitter] # (nikola: what is this used for?)

jfind_smallvr_track = jtm.addJetFinder("AntiKtVR50Rmax4Rmin0TrackJets", "AntiKt", 0.4, "pv0track", "smallvr_track_modifiers",
                                        ghostArea = 0 , ptmin = 2000, ptminFilter = 7000,
                                        variableRMinRadius = 0, variableRMassScale = 50000, calibOpt = "none")

from JetRec.JetRecConf import JetAlgorithm
jetalg_smallvr_track= JetAlgorithm("jfind_smallvr_track", Tools = [jfind_smallvr_track])

FTAG5Seq += jetalg_smallvr_track

from JetRec.JetRecConf import PseudoJetGetter
jtm += PseudoJetGetter(
     "gvr50rmax4rmin0trackget", # give a unique name
     InputContainer = jetFlags.containerNamePrefix() + "AntiKtVR50Rmax4Rmin0TrackJets", # SG key
     Label = "GhostVR50Rmax4Rmin0TrackJet", # this is the name you'll use to retrieve ghost associated VR track jets
     OutputContainer = "PseudoJetGhostVR50Rmax4Rmin0TrackJet",
     SkipNegativeEnergy = True,
     GhostScale = 1.e-20, # this makes the PseudoJet Ghosts, and thus the reco flow will treat them as such
   )

jtm.gettersMap["lctopo"]+= [jtm.gvr50rmax4rmin0trackget] # has to happen before the trimmed jet gets clustered for the VR track jets to be ghost associated

# trim the large-R jets - the VR track jets will become ghost associated to the large-R jets and stored in the trimmed large-R jet collection (nikola: confirm)
addDefaultTrimmedJets(FTAG5Seq, "FTAG5")
applyJetCalibration_CustomColl("AntiKt10LCTopoTrimmedPtFrac5SmallR20", FTAG5Seq)

# run b-tagging on the VR track jets
from BTagging.BTaggingFlags import BTaggingFlags

BTaggingFlags.CalibrationChannelAliases += ["AntiKtVR50Rmax4Rmin0Track->AntiKt4EMTopo"]

from DerivationFrameworkFlavourTag.FlavourTagCommon import FlavorTagInit
# must re-tag AntiKt4LCTopoJets and AntiKt4PV0TrackJets to make JetFitterNN work with corresponding VR jets (nikola: why?)
# also, re-tag R=0.2 track jets
FlavorTagInit(JetCollections = ["AntiKt4PV0TrackJets", "AntiKtVR50Rmax4Rmin0TrackJets", "AntiKt2PV0TrackJets"], Sequencer = FTAG5Seq )

#====================================================================
# ATTEMPT TO FIX TRUTH LABELLING BUG
#====================================================================
#from JetRec.JetRecConf import JetRecTool
#JetRecTool_AntiKt10LCTopo = JetRecTool("AODFix_AntiKt10LCTopoJets", InputContainer = "AntiKt10LCTopoJets", OutputContainer = "AntiKt10LCTopoJets", JetModifiers = [ToolSvc.AODFix_jetdrlabeler]) # does not use the right DRMax for large-R jets!!
#ToolSvc += JetRecTool_AntiKt10LCTopo  

#====================================================================
# SKIMMING TOOLS
#====================================================================
# this is a basic cut for Higgs tagging studies
offlineExpression = '((count (AntiKt10LCTopoTrimmedPtFrac5SmallR20Jets.m > 50 * GeV && AntiKt10LCTopoTrimmedPtFrac5SmallR20Jets.pt > 250 * GeV && (abs(AntiKt10LCTopoTrimmedPtFrac5SmallR20Jets.eta) < 2.0)) > 0 ))'

if globalflags.DataSource()=='data':
    triggers=[
        # primay triggers suggested for periodC
        "HLT_e24_lhmedium_L1EM18VH",
        "HLT_e60_lhmedium",
        "HLT_e120_lhloose",
        "HLT_e24_lhmedium_iloose_L1EM18VH",
        "HLT_e60_lhmedium",
        "HLT_e120_lhloose",
        "HLT_mu20_iloose_L1MU15",
        "HLT_mu40",
        # other single lepton triggers
        "HLT_e24_lhtight_iloose_L1EM20VH",
        "HLT_e24_tight_iloose_L1EM20VH",
        "HLT_mu14_iloose",
        "HLT_e17_loose"
        ]

    ORStr=" || "
    triggerStr=ORStr.join(triggers)
    triggerExpression = "((EventInfo.eventTypeBitmask==1) || (" + triggerStr +" ))"
    expression = offlineExpression+' && '+triggerExpression

else:
    triggers = []
    expression = offlineExpression

#====================================================================
# CREATE THE DERIVATION KERNEL ALGORITHM AND PASS THE ABOVE TOOLS
#====================================================================

# The name of the kernel (LooseSkimKernel in this case) must be unique to this derivation
from DerivationFrameworkCore.DerivationFrameworkCoreConf import DerivationFramework__DerivationKernel
DerivationFrameworkJob += FTAG5Seq
FTAG5Seq += CfgMgr.DerivationFramework__DerivationKernel("FTAG5Kernel")

#====================================================================
# SET UP STREAM
#====================================================================

# The base name (DAOD_FTAG5 here) must match the string in
streamName = derivationFlags.WriteDAOD_FTAG5Stream.StreamName
fileName   = buildFileName( derivationFlags.WriteDAOD_FTAG5Stream )
FTAG5Stream = MSMgr.NewPoolRootStream( streamName, fileName )
# Only events that pass the filters listed below are written out.
# Name must match that of the kernel above
# AcceptAlgs  = logical OR of filters
# RequireAlgs = logical AND of filters
FTAG5Stream.AcceptAlgs(["FTAG5Kernel"])

from DerivationFrameworkCore.SlimmingHelper import SlimmingHelper
FTAG5SlimmingHelper = SlimmingHelper("FTAG5SlimmingHelper")

# NB: the BTagging_AntiKt4EMTopo smart collection includes both AntiKt4EMTopoJets and BTagging_AntiKt4EMTopo
# container variables. Thus BTagging_AntiKt4EMTopo is needed in SmartCollections as well as AllVariables
FTAG5SlimmingHelper.AppendToDictionary = {
"AntiKtVR50Rmax4Rmin0TrackJets"               :   "xAOD::JetContainer"        ,
"AntiKtVR50Rmax4Rmin0TrackJetsAux"            :   "xAOD::JetAuxContainer"     ,
"BTagging_AntiKtVR50Rmax4Rmin0Track"          :   "xAOD::BTaggingContainer"   ,
"BTagging_AntiKtVR50Rmax4Rmin0TrackAux"       :   "xAOD::BTaggingAuxContainer",
"AntiKt10LCTopoTrimmedPtFrac5SmallR20Jets"    :   "xAOD::JetContainer"        ,
"AntiKt10LCTopoTrimmedPtFrac5SmallR20JetsAux" :   "xAOD::JetAuxContainer"     ,
}

FTAG5SlimmingHelper.SmartCollections = ["Electrons","Muons",
                                        "MET_Reference_AntiKt4EMTopo",
                                        "AntiKt4EMTopoJets",
                                        "BTagging_AntiKt4EMTopo"]

FTAG5SlimmingHelper.AllVariables = ["AntiKt3PV0TrackJets",
                                    "AntiKt2PV0TrackJets",
                                    "AntiKt4PV0TrackJets",
                                    "AntiKt4TruthJets",
                                    "BTagging_AntiKt4EMTopo",
                                    "BTagging_AntiKt2Track",
                                    "BTagging_AntiKt3Track",
                                    "BTagging_AntiKt4EMTopoJFVtx",
                                    "BTagging_AntiKt2TrackJFVtx",
                                    "BTagging_AntiKt3TrackJFVtx",
                                    "BTagging_AntiKt4EMTopoSecVtx",
                                    "BTagging_AntiKt2TrackSecVtx",
                                    "BTagging_AntiKt3TrackSecVtx",
                                    "TruthVertices",
                                    "TruthParticles",
                                    "TruthEvents",
                                    "MET_Truth",
				    "MET_TruthRegions",
				    "InDetTrackParticles",
				    "PrimaryVertices",
				    "AntiKtVR50Rmax4Rmin0TrackJets", 
				    "BTagging_AntiKtVR50Rmax4Rmin0Track",
                                    "AntiKt10LCTopoJets",
                                    "AntiKt10LCTopoTrimmedPtFrac5SmallR20Jets",
                                    "CaloCalTopoClusters"
                                    ]

from DerivationFrameworkCore.AntiKt4EMTopoJetsCPContent import AntiKt4EMTopoJetsCPContent

FTAG5SlimmingHelper.ExtraVariables.append(AntiKt4EMTopoJetsCPContent[1].replace("AntiKt4EMTopoJetsAux","AntiKt10LCTopoJets"))

FTAG5SlimmingHelper.IncludeMuonTriggerContent = True
FTAG5SlimmingHelper.IncludeEGammaTriggerContent = True
FTAG5SlimmingHelper.IncludeJetTriggerContent = True
FTAG5SlimmingHelper.IncludeEtMissTriggerContent = True
FTAG5SlimmingHelper.IncludeBJetTriggerContent = True

FTAG5SlimmingHelper.AppendContentToStream(FTAG5Stream)
