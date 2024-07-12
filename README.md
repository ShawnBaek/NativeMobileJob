# NativeMobileJob
Fetch job listings directly from the career pages of mobile-first companies.

# Motivation
After being laid off, ironically on April Fools' Day 2024, I struggled to find a mobile engineer position despite over a decade of software engineering experience. I discovered that many companies are reluctant to hire senior or staff-level mobile engineers, and finding companies that support visa sponsorship is particularly challenging. To assist others in similar situations, I decided to create and share a list of opportunities specifically for mobile engineers. I hope this resource proves helpful to many in the field.

Finding mobile jobs on LinkedIn can be unhelpful due to the lack of specific filters such as minimum target iOS version, team size, and tech stacks. Additionally, mobile job listings today often include roles for hybrid frameworks like React Native and Flutter, alongside native positions. Furthermore, many companies do not post job openings on platforms like LinkedIn to save costs. Therefore, it is often more effective to check the hiring pages of companies directly rather than relying on platforms like LinkedIn.

To focus on native mobile jobs, I select companies with dedicated mobile teams that develop apps using native technologies.

<img src="https://github.com/ShawnBaek/nativeMobileJob/assets/12643700/5695420f-c001-48bf-a514-34d27d3f7097" width=500>
<br>
https://www.linkedin.com/posts/sergey-pekar_ios-reactnative-memes-activity-7067889459379228672-fAbo

# Contribution
Please suggest mobile-first companies along with detailed information, including:
- Career site URL
- Minimum target iOS version
- Tech stacks (Swift / Objective-C / Architecture)
- Team size

# Mobile First Company Lists
| Company        | Country             | Minimum Support iOS | Support Visa | Status | Career Page                                 | Products                                                                                          |
|----------------|---------------------|---------------------|--------------|--------|---------------------------------------------|---------------------------------------------------------------------------------------------------|
| Apple          | USA, Canada, UK     |                     |              | Added  | [Link](https://jobs.apple.com)              |                                                                                                   |
| Uber           | USA, Canada, Brazil |                     |              | Added  | [Link](https://www.uber.com/us/en/careers/) |                                                                                                   |
| Meta           | USA, UK             |                     | Yes          |        | [Link](https://www.metacareers.com)         |                                                                                                   |
| Bending Spoons | Italy               |                     | Yes          |        | [Link](https://jobs.bendingspoons.com)      |                                                                                                   |
| amo            | France              |                     | Yes          |        | [Link](https://amo.co/jobs/)                | [ID](https://get.amo.co/id) [Capture](https://get.amo.co/capture) [Bump](https://get.amo.co/bump) |
| Amazon         | USA, UK, Spain      |                     | Yes          |        | [Link](https://www.amazon.jobs/en/)         |                                                                                                   |


# Demo
https://github.com/ShawnBaek/nativeMobileJob/assets/12643700/ce2d4e75-6e77-44bc-968c-688d4a716d18

# How to use

```swift
import SwiftJobs

do {
      let appleJobs = try await Apple.jobs()
      let uberJobs = try await Uber.jobs()
            
      for item in appleJobs {
          print("\(item.title) - \(item.description) - \(item.location)")
      }
      
      for item in uberJobs {
          print("\(item.title) - \(item.description) - \(item.location)")
      }
}
catch {
      //handle errors
}
```

# Next Step
- Android jobs

# Dependencies
SwiftSoup
