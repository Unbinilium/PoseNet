import CoreGraphics

enum Algorithm: Int {
    case single = 0
    case multiple = 1
}

struct PoseBuilderConfiguration {    
    var algorithm = Algorithm.multiple
    
    // The minimum value for valid joints in a pose.
    var jointConfidenceThreshold = 0.3

    // The minimum value for a valid pose.
    var poseConfidenceThreshold = 0.5
    
    // The maximum number of poses returned.
    //
    // - Note: This parameter only applies to the multiple-pose algorithm.
    let maxPoseCount = 15
    
    // Search radius used when checking if a joint has the greatest confidence amongst its neighbors.
    //
    // - Note: This parameter only applies to the multiple-pose algorithm.
    var localSearchRadius = 3

    // The minimum distance between two distinct joints of the same type.
    //
    // - Note: This parameter only applies to the multiple-pose algorithm.
    var matchingJointDistance = 40.0

    // The number of iterations performed to refine an adjacent joint's position.
    //
    // - Note: This parameter only applies to the multiple-pose algorithm.
    var adjacentJointOffsetRefinementSteps = 3
}
