class PagesController < ApplicationController
  def home
    @path_title = "Learn Ruby on Rails Path"
    @path_subtitle = "Become a Ruby on Rails developer in record time."

    @level = {
      name: "Level One",
      heading: "Prerequisites",
      description: "Let's get our foundational knowledge of Ruby, SQL, and HTML together in this prerequisite level.",
      series: 3,
      hours: 10
    }

    @teacher = {
      name: "Collin Jilbert",
      role: "Lead Instructor",
      initials: "CJ"
    }

    @courses = [
      {
        title: "Ruby for Beginners",
        description: "Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It is the foundation for the Ruby on Rails web framework and we'll teach you the basics so you can get started with Rails.",
        lessons: "10 Lessons",
        duration: "5h 50m",
        level: "Beginner",
        cta: "Start Series",
        cover_tone: "from-slate-950 via-slate-900 to-slate-700"
      },
      {
        title: "SQL for Beginners",
        description: "Structured Query Language is a domain-specific language for managing relational data. Learn practical SQL you will use in every Rails project.",
        lessons: "8 Lessons",
        duration: "4h 45m",
        level: "Beginner",
        cta: "Start Series",
        cover_tone: "from-orange-950 via-red-900 to-amber-800"
      },
      {
        title: "HTML and CSS Foundations",
        description: "Build confidence with semantic HTML and modern CSS so your Rails features ship with clean, responsive, and maintainable interfaces.",
        lessons: "6 Lessons",
        duration: "4h 00m",
        level: "Beginner",
        cta: "Start Series",
        cover_tone: "from-blue-950 via-indigo-900 to-cyan-800"
      }
    ]
  end
end
