//
//  File.swift
//  Arrow Detect Offline
//
//  Created by Eesa Adam on 05/08/2025.
//


extension Award {
    static var allAwards: [Award] = [
        Award(name: "White Arrow", maximumTargetSize: 80, minimumDistance: 10, noOfRequirements: 33, awardNo: 0),
        Award(name: "Black Arrow", maximumTargetSize: 80, minimumDistance: 14, noOfRequirements: 8, awardNo: 1),
        Award(name: "Blue Arrow", maximumTargetSize: 80, minimumDistance: 18, noOfRequirements: 11, awardNo: 2),
        Award(name: "Red Arrow", maximumTargetSize: 60, minimumDistance: 18, noOfRequirements: 9, awardNo: 3),
        Award(name: "Gold Arrow", maximumTargetSize: 40, minimumDistance: 18, noOfRequirements: 8, awardNo: 4),
    ]
    static var allSkills: [[Skill]] = [
        [
            Skill(award: allAwards[0], name: "Performance (marked automatically)", skillNo: 0),
            Skill(award: allAwards[0], name: "Warm-up", skillNo: 1),
            Skill(award: allAwards[0], name: "Feet position (Stance)", skillNo: 2),
            Skill(award: allAwards[0], name: "Safe and proper arrow loading", skillNo: 3),
            Skill(award: allAwards[0], name: "Body setting (before drawing and at full draw)", skillNo: 4),
            Skill(award: allAwards[0], name: "Raising", skillNo: 5),
            Skill(award: allAwards[0], name: "Body setting (end of draw)", skillNo: 6),
            Skill(award: allAwards[0], name: "Acoustic signals", skillNo: 7),
            Skill(award: allAwards[0], name: "Bow safety", skillNo: 8),
            Skill(award: allAwards[0], name: "Arrow loading safety", skillNo: 9),
            Skill(award: allAwards[0], name: "Safe arrow recuperation", skillNo: 10),
            Skill(award: allAwards[0], name: "Equipment terminonology", skillNo: 11),
            Skill(award: allAwards[0], name: "Bow preparation", skillNo: 12),
            Skill(award: allAwards[0], name: "Shooting direction", skillNo: 13),
            Skill(award: allAwards[0], name: "Safety and etiquete on the shooting line", skillNo: 14),
            Skill(award: allAwards[0], name: "Scoring", skillNo: 15)
        ],
        [
            Skill(award: allAwards[1], name: "Performance (marked automatically)", skillNo: 0),
            Skill(award: allAwards[1], name: "Draw process", skillNo: 1),
            Skill(award: allAwards[1], name: "Main action (What is happening at full draw?)", skillNo: 2),
            Skill(award: allAwards[1], name: "Visual attention", skillNo: 3),
            Skill(award: allAwards[1], name: "Arrow safety and checking", skillNo: 4)
        ],
        [
            Skill(award: allAwards[2], name: "Performance (marked automatically)", skillNo: 0),
            Skill(award: allAwards[2], name: "String hand", skillNo: 1),
            Skill(award: allAwards[2], name: "Facial marks", skillNo: 2),
            Skill(award: allAwards[2], name: "Feeling attention", skillNo: 3),
            Skill(award: allAwards[2], name: "Bow knowledge", skillNo: 4),
            Skill(award: allAwards[2], name: "Arrow maintenance", skillNo: 5)
        ],
        [
            Skill(award: allAwards[3], name: "Performance (marked automatically)", skillNo: 0),
            Skill(award: allAwards[3], name: "Release", skillNo: 1),
            Skill(award: allAwards[3], name: "Bow hand", skillNo: 2),
            Skill(award: allAwards[3], name: "Bow arm", skillNo: 3),
            Skill(award: allAwards[3], name: "Archery disciplines", skillNo: 4),
            Skill(award: allAwards[3], name: "Arrow maintenace", skillNo: 5)
        ],
        [
            Skill(award: allAwards[4], name: "Performance (marked automatically)", skillNo: 0),
            Skill(award: allAwards[4], name: "String clearance", skillNo: 1),
            Skill(award: allAwards[4], name: "Follow-through", skillNo: 2),
            Skill(award: allAwards[4], name: "Sequence", skillNo: 3),
            Skill(award: allAwards[4], name: "Tournament registration process", skillNo: 4),
            Skill(award: allAwards[4], name: "Arrow setting", skillNo: 5)
        ]
    ]
    static var allRequirements: [[Requirement]] = [
        [
            Requirement(skill: allSkills[0][0], description: "Achieve a minimum score of 86 (barebow) or 115 (recurve) at minimum distance of 10 meters using a target with a maximum size of 80cm", requirementNo: 0),
            Requirement(skill: allSkills[0][1], description: "Executing the warm-up routine", requirementNo: 1),
            Requirement(skill: allSkills[0][2], description: "Feet either side of the shooting line ", requirementNo: 2),
            Requirement(skill: allSkills[0][2], description: "Feet at shoulder width apart", requirementNo: 3),
            Requirement(skill: allSkills[0][2], description: "Line of feet square to the shooting line ", requirementNo: 4),
            Requirement(skill: allSkills[0][2], description: "Feet parallel", requirementNo: 5),
            Requirement(skill: allSkills[0][3], description: "Implemented with bow vertical", requirementNo: 6),
            Requirement(skill: allSkills[0][3], description: "No finger pressing the arrow on rest", requirementNo: 7),
            Requirement(skill: allSkills[0][3], description: "Arrow properly oriented (index fletching away from bow window)", requirementNo: 8),
            Requirement(skill: allSkills[0][4], description: "Vertical body", requirementNo: 9),
            Requirement(skill: allSkills[0][4], description: "Balance equal on both feet", requirementNo: 10),
            Requirement(skill: allSkills[0][4], description: "Spine and shoulders making a cross shape ", requirementNo: 11),
            Requirement(skill: allSkills[0][5], description: "Synchronized hands", requirementNo: 12),
            Requirement(skill: allSkills[0][5], description: "Raise hands while keeping the shoulders down", requirementNo: 13),
            Requirement(skill: allSkills[0][5], description: "Hands at same height and at nose or eye level once raised", requirementNo: 14),
            Requirement(skill: allSkills[0][5], description: "Arrow parallel to the floor once raised", requirementNo: 15),
            Requirement(skill: allSkills[0][6], description: "Let the string hand land on face (chin and/or lips do not reach forward to the string)", requirementNo: 16),
            Requirement(skill: allSkills[0][7], description: "Explain the acoustic signals", requirementNo: 17),
            Requirement(skill: allSkills[0][8], description: "No dry firing (dry loosing)", requirementNo: 18),
            Requirement(skill: allSkills[0][8], description: "Place the bow in the equipment lane after end", requirementNo: 19),
            Requirement(skill: allSkills[0][9], description: "Load the arrow on the bow only when the Field of play is empty, the shooting signal has been given and", requirementNo: 20),
            Requirement(skill: allSkills[0][9], description: "done only when both feet are set, one on each side of the shooting line", requirementNo: 21),
            Requirement(skill: allSkills[0][10], description: "Walk carefully to the target (not running and watching his/her step)", requirementNo: 22),
            Requirement(skill: allSkills[0][10], description: "Stand to the side of the target (not behind arrows)", requirementNo: 23),
            Requirement(skill: allSkills[0][10], description: "Properly pull the arrow out of the target (or grass)", requirementNo: 24),
            Requirement(skill: allSkills[0][11], description: "Can name 5 parts or components of the bow", requirementNo: 25),
            Requirement(skill: allSkills[0][12], description: "Know how to properly mount and remove the limbs on/from the riser", requirementNo: 26),
            Requirement(skill: allSkills[0][12], description: "Can brace his or her bow", requirementNo: 27),
            Requirement(skill: allSkills[0][13], description: "Only draw towards a clear target butt from the shooting line (not toward anyone or the sky)", requirementNo: 28),
            Requirement(skill: allSkills[0][14], description: "Not disturbing (touching or talking to) other shooting archers", requirementNo: 29),
            Requirement(skill: allSkills[0][14], description: "Properly retrieve an arrow that dropped on the floor", requirementNo: 30),
            Requirement(skill: allSkills[0][15], description: "Identify each arrow’s value", requirementNo: 31),
            Requirement(skill: allSkills[0][15], description: "Complete a scorecard for a complete round", requirementNo: 32)
        ],
        [
            Requirement(skill: allSkills[1][0], description: "Achieve a minimum score of 86 (barebow) or 115 (recurve) at minimum distance of 14 meters using a target with a maximum size of 80cm", requirementNo: 0),
            Requirement(skill: allSkills[1][1], description: "Done with two hands always at the same level (or arrow always parallel to floor)", requirementNo: 1),
            Requirement(skill: allSkills[1][1], description: "Draw in shooting plane ", requirementNo: 2),
            Requirement(skill: allSkills[1][2], description: "Stationary arrow point (no draw creeping) - or better - arrow point constantly moving back", requirementNo: 3),
            Requirement(skill: allSkills[1][2], description: "Consistent distances between arrow and bow shoulder (vertically and horizontally)", requirementNo: 4),
            Requirement(skill: allSkills[1][3], description: "Can observe himself (or herself) in a mirror while releasing", requirementNo: 5),
            Requirement(skill: allSkills[1][4], description: "Know what to do in the case of a hanging arrow on the target", requirementNo: 6),
            Requirement(skill: allSkills[1][4], description: "Can check the straightness of an aluminium arrow or the integrity of a carbon arrow", requirementNo: 7)
        ],
        [
            Requirement(skill: allSkills[2][0], description: "Achieve a minimum score of 86 (barebow) or 115 (recurve) at minimum distance of 18 meters using a target with a maximum size of 80cm", requirementNo: 0),
            Requirement(skill: allSkills[2][1], description: "Flat back of hand (no knuckles pointed out)", requirementNo: 1),
            Requirement(skill: allSkills[2][1], description: "3 fingers are used for gripping the string", requirementNo: 2),
            Requirement(skill: allSkills[2][1], description: "Vertical back of hand", requirementNo: 3),
            Requirement(skill: allSkills[2][1], description: "Consistent grip", requirementNo: 4),
            Requirement(skill: allSkills[2][2], description: "Consistent location", requirementNo: 5),
            Requirement(skill: allSkills[2][2], description: "Provide “decent” alignment between arrow and string forearm", requirementNo: 6),
            Requirement(skill: allSkills[2][2], description: "Can align the string", requirementNo: 7),
            Requirement(skill: allSkills[2][3], description: "Can shoot with eyes closed", requirementNo: 8),
            Requirement(skill: allSkills[2][4], description: "Can give the overall description of 3 types of bow", requirementNo: 9),
            Requirement(skill: allSkills[2][5], description: "Knows how to replace a nock", requirementNo: 10)
        ],
        [
            Requirement(skill: allSkills[3][0], description: "Achieve a minimum score of 86 (barebow) or 115 (recurve) at minimum distance of 18 meters using a target with a maximum size of 60cm", requirementNo: 0),
            Requirement(skill: allSkills[3][1], description: "String hand moves along jaw or neck", requirementNo: 1),
            Requirement(skill: allSkills[3][1], description: "Backwards motion generated by the follow-up contraction of the back and posterior string shoulder muscles", requirementNo: 2),
            Requirement(skill: allSkills[3][2], description: "Consistent bow hand on grip", requirementNo: 3),
            Requirement(skill: allSkills[3][2], description: "Relaxed bow hand allowing the use of a sling", requirementNo: 4),
            Requirement(skill: allSkills[3][3], description: "Elbow properly orientated", requirementNo: 5),
            Requirement(skill: allSkills[3][3], description: "Stationary upon release or moving a little toward the back due the follow-up contraction of the back and posterior bow shoulder muscles", requirementNo: 6),
            Requirement(skill: allSkills[3][4], description: "Can give the overall description of 3 archery disciplines", requirementNo: 7),
            Requirement(skill: allSkills[3][5], description: "Know how to fit and glue a point, and fletch an arrow", requirementNo: 8)
        ],
        [
            Requirement(skill: allSkills[4][0], description: "Achieve a minimum score of 86 (barebow) or 115 (recurve) at minimum distance of 18 meters using a target with a maximum size of 40cm", requirementNo: 0),
            Requirement(skill: allSkills[4][1], description: "Successful string clearance test (bridge of tape for instance)", requirementNo: 1),
            Requirement(skill: allSkills[4][2], description: "Impassive face upon release", requirementNo: 0),
            Requirement(skill: allSkills[4][2], description: "Continued aiming upon release", requirementNo: 1),
            Requirement(skill: allSkills[4][3], description: "Repeat the shooting steps with consistency", requirementNo: 2),
            Requirement(skill: allSkills[4][3], description: "Consistent shooting time (+/- 10 seconds per end of 3 arrows)", requirementNo: 3),
            Requirement(skill: allSkills[4][4], description: "Know the registration process (of the club) for a local tournament", requirementNo: 4),
            Requirement(skill: allSkills[4][5], description: "Know how to affix an arrow-rest and make a nocking point", requirementNo: 5)
        ]
    ]
}
