//
//  StepsModel.swift
//  ChefsChoice
//
//  Created by Дмитрий on 02.03.2023.
//

import UIKit

struct StepsModel {
    let readyInMinutes: Int
    let servings: Int
    let analyzedInstructions: [AnalyzedInstruction]
    
    static let steps = StepsModel(readyInMinutes: 45, servings: 6, analyzedInstructions: analiz)
}

struct AnalyzedInstruction {
    let stepNumber: Int
    let stepInformation: String
    let ingredients: [NamesIngedients]
}

struct NamesIngedients {
    let name: String
}

var names = [NamesIngedients(name: "dgdg dgdfgds waf wsr")]

let analiz = [AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names),AnalyzedInstruction(stepNumber: 5, stepInformation: "xfgbdfbdbhdb bdb drb dtbd dbhd dd hdryhh drthryhdrge geg eg eg ese e g ege getgetgth rssrtgrst tsg rsrtgg stg srgrstg rgtsr  g gs r grsggt  sgergr sgrstg rsg rtg  sggs rstg rg sgrtgrt g sg rtgt r", ingredients: names)]
