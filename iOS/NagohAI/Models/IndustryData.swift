import Foundation

// MARK: - Industry enum

enum Industry: String, CaseIterable, Identifiable, Codable {
    case etsy             = "etsy"
    case realtor          = "realtor"
    case landlord         = "landlord"
    case coffee           = "coffee"
    case landscaping      = "landscaping"
    case roofing          = "roofing"
    case plumbing         = "plumbing"
    case salon            = "salon"
    case photography      = "photography"
    case personalTraining = "personal_training"
    case insurance        = "insurance"
    case consulting       = "consulting"
    case general          = "general"

    var id: String { rawValue }

    var displayName: String {
        INDUSTRIES[self]?.name ?? rawValue
    }
}

// MARK: - Data types

struct QuickStarter: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let desc: String
    let prompt: String
}

struct IdeaItem: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let desc: String
}

struct IndustryConfig {
    let name: String
    let placeholder: String
    let emptyMsg: String
    let quickStarters: [QuickStarter]
    let ideas: [IdeaItem]
    let tonePrompts: [String: String]
}

// MARK: - All industry data (matches index.html exactly)

let INDUSTRIES: [Industry: IndustryConfig] = [

    .etsy: IndustryConfig(
        name: "🛍️ Etsy & Craft Sellers",
        placeholder: "Ask anything — listing copy, captions, pricing, customer replies…",
        emptyMsg: "Perfect for selling handmade goods, crafts, and creative items.",
        quickStarters: [
            QuickStarter(emoji: "📝", title: "Product Listing",  desc: "Write descriptions that sell",   prompt: "Write an Etsy product description for: "),
            QuickStarter(emoji: "📸", title: "Social Captions",  desc: "Instagram, Facebook & more",     prompt: "Write 5 Instagram captions for my craft shop that sells: "),
            QuickStarter(emoji: "💌", title: "Customer Reply",   desc: "Handle messages with ease",      prompt: "Write a friendly reply to this customer message: "),
            QuickStarter(emoji: "💰", title: "Pricing Help",     desc: "Price your work fairly",         prompt: "Give me 10 pricing strategies for my craft business that makes: "),
            QuickStarter(emoji: "🔍", title: "SEO & Tags",       desc: "Get found by buyers",            prompt: "Write SEO tags and keywords for my Etsy shop that sells: "),
        ],
        ideas: [
            IdeaItem(emoji: "🎄", title: "Holiday announcement", desc: "Let buyers know your hours"),
            IdeaItem(emoji: "📅", title: "Weekly content plan",  desc: "Never run out of post ideas"),
            IdeaItem(emoji: "💝", title: "Thank-you note",       desc: "Delight your customers"),
            IdeaItem(emoji: "🔎", title: "Trending keywords",    desc: "Improve your SEO"),
            IdeaItem(emoji: "🛡️", title: "Handle bad reviews",  desc: "Respond with grace"),
            IdeaItem(emoji: "🗓️", title: "30-day social plan",  desc: "Stay consistent online"),
            IdeaItem(emoji: "📦", title: "Shipping tips",        desc: "Keep buyers happy"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a warm, encouraging assistant for Etsy sellers, crafters, and artists. Be supportive and clear. Use simple language. Help them feel confident about their business and creative work.",
            "professional": "You are NAGOH AI, a professional business assistant for Etsy sellers. Provide clear, well-structured advice about listings, pricing, and customer service.",
            "playful":      "You are NAGOH AI, a fun and enthusiastic assistant for creative makers! Be upbeat and make running a craft business feel exciting. Use emojis occasionally.",
            "concise":      "You are NAGOH AI, an assistant for Etsy sellers. Be extremely concise. Bullet points preferred. No fluff.",
        ]
    ),

    .realtor: IndustryConfig(
        name: "🏠 Real Estate Agents",
        placeholder: "Ask anything — listings, social posts, client follow-ups, property promotions…",
        emptyMsg: "Create professional property listings and marketing content.",
        quickStarters: [
            QuickStarter(emoji: "🏘️", title: "Property Listing",  desc: "MLS-ready descriptions",     prompt: "Write a compelling real estate listing description for: "),
            QuickStarter(emoji: "📸", title: "Social Post",        desc: "Facebook, Instagram ads",    prompt: "Write a social media post to promote this property: "),
            QuickStarter(emoji: "💌", title: "Client Follow-up",   desc: "Nurture leads",              prompt: "Write a follow-up email to a client who viewed this property: "),
            QuickStarter(emoji: "📊", title: "Market Analysis",    desc: "Explain neighborhood value", prompt: "Write a market analysis summary for this neighborhood: "),
            QuickStarter(emoji: "🎯", title: "Open House Invite",  desc: "Drive attendance",           prompt: "Write an open house invitation email for: "),
        ],
        ideas: [
            IdeaItem(emoji: "🏡", title: "New listing announcement", desc: "Alert your sphere"),
            IdeaItem(emoji: "📍", title: "Neighborhood guide",       desc: "Show local value"),
            IdeaItem(emoji: "💼", title: "Buyer qualification",      desc: "Pre-qualify leads"),
            IdeaItem(emoji: "🔑", title: "Closing congrats",         desc: "Build relationships"),
            IdeaItem(emoji: "🏆", title: "Success story",            desc: "Share testimonials"),
            IdeaItem(emoji: "💡", title: "Investment tips",          desc: "Attract investors"),
            IdeaItem(emoji: "📞", title: "Cold outreach",            desc: "Expired/FSBO scripts"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a helpful assistant for real estate professionals. Be warm, professional, and client-focused. Create content that builds trust and showcases properties effectively.",
            "professional": "You are NAGOH AI, a professional real estate assistant. Provide clear, market-smart advice about listings, marketing, and client management.",
            "playful":      "You are NAGOH AI, an enthusiastic real estate marketing assistant. Be energetic and make property marketing fun and engaging.",
            "concise":      "You are NAGOH AI, a real estate assistant. Be concise and direct. Focus on key selling points and call-to-action.",
        ]
    ),

    .landlord: IndustryConfig(
        name: "🏢 Landlords & Property Managers",
        placeholder: "Ask anything — tenant communication, rent reminders, maintenance requests…",
        emptyMsg: "Professional communication templates for property management.",
        quickStarters: [
            QuickStarter(emoji: "💰", title: "Late Rent Notice",    desc: "Professional reminder",       prompt: "Write a professional reminder email to a tenant who is late on rent: "),
            QuickStarter(emoji: "⚠️", title: "Rule Violation",      desc: "Address issues firmly",       prompt: "Write a letter to a tenant about this lease violation: "),
            QuickStarter(emoji: "🔧", title: "Repair Request Reply", desc: "Acknowledge & schedule",    prompt: "Write a professional response to a tenant maintenance request: "),
            QuickStarter(emoji: "📋", title: "Lease Renewal",        desc: "Terms & options",            prompt: "Write a lease renewal offer email for a tenant: "),
            QuickStarter(emoji: "🚪", title: "Move-out Notice",      desc: "Professional & clear",       prompt: "Write a move-out inspection notification email: "),
        ],
        ideas: [
            IdeaItem(emoji: "📅", title: "Rent due reminder",   desc: "Friendly advance notice"),
            IdeaItem(emoji: "🔒", title: "Security deposit info", desc: "Clear expectations"),
            IdeaItem(emoji: "🏠", title: "Property update",      desc: "Announce improvements"),
            IdeaItem(emoji: "📞", title: "Emergency procedure",  desc: "Tenant communication"),
            IdeaItem(emoji: "📝", title: "Lease clarification",  desc: "Prevent disputes"),
            IdeaItem(emoji: "🎯", title: "Tenant screening",     desc: "Professional criteria"),
            IdeaItem(emoji: "🤝", title: "Dispute resolution",   desc: "De-escalation scripts"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a helpful property management assistant. Be professional yet approachable. Help landlords communicate clearly and fairly with tenants.",
            "professional": "You are NAGOH AI, a professional property management assistant. Provide clear, legally-aware communication templates that protect landlord interests.",
            "playful":      "You are NAGOH AI, a property management assistant. Keep tone professional but personable. Make interactions pleasant despite difficult topics.",
            "concise":      "You are NAGOH AI, a property management assistant. Be direct and clear. Include key information without unnecessary details.",
        ]
    ),

    .coffee: IndustryConfig(
        name: "☕ Coffee Shops & Cafés",
        placeholder: "Ask anything — menu descriptions, promotions, staff communication…",
        emptyMsg: "Marketing and communication tools for coffee shops and cafés.",
        quickStarters: [
            QuickStarter(emoji: "☕", title: "Menu Item",        desc: "Appetizing descriptions", prompt: "Write an appetizing description for this coffee shop menu item: "),
            QuickStarter(emoji: "📢", title: "Promotion Post",   desc: "Social media buzz",       prompt: "Write a social media post promoting our: "),
            QuickStarter(emoji: "👥", title: "Staff Memo",       desc: "Clear instructions",      prompt: "Write a staff memo about: "),
            QuickStarter(emoji: "🎁", title: "Loyalty Program",  desc: "Drive repeat customers",  prompt: "Write copy for our coffee shop loyalty program: "),
            QuickStarter(emoji: "🌟", title: "Event Announcement", desc: "Live music, tastings…", prompt: "Write an announcement for our coffee shop event: "),
        ],
        ideas: [
            IdeaItem(emoji: "📱", title: "New seasonal drink",  desc: "Build anticipation"),
            IdeaItem(emoji: "🏆", title: "Customer spotlight",  desc: "Build community"),
            IdeaItem(emoji: "🎵", title: "Live music night",    desc: "Promote entertainment"),
            IdeaItem(emoji: "💝", title: "Gift card promo",     desc: "Holiday sales"),
            IdeaItem(emoji: "☕", title: "Coffee tasting",      desc: "Educational event"),
            IdeaItem(emoji: "🤝", title: "Partnership post",    desc: "Local bakery collab"),
            IdeaItem(emoji: "📸", title: "Behind the scenes",   desc: "Show your craft"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a warm and creative assistant for coffee shop owners. Be enthusiastic about coffee culture. Make content feel welcoming and community-focused.",
            "professional": "You are NAGOH AI, a professional business assistant for cafés. Provide clear, consistent messaging that builds brand loyalty.",
            "playful":      "You are NAGOH AI, a fun and witty assistant for coffee shops. Use coffee humor and personality. Make customers smile.",
            "concise":      "You are NAGOH AI, a coffee shop assistant. Be snappy and memorable. Get people in the door.",
        ]
    ),

    .landscaping: IndustryConfig(
        name: "🌳 Landscaping & Yard Services",
        placeholder: "Ask anything — quotes, project descriptions, customer updates…",
        emptyMsg: "Marketing and communication for landscaping and outdoor services.",
        quickStarters: [
            QuickStarter(emoji: "🌿", title: "Service Description", desc: "Explain your work",     prompt: "Write a description of our landscaping service: "),
            QuickStarter(emoji: "📸", title: "Before/After Post",   desc: "Social media showcase", prompt: "Write social media post describing this transformation: "),
            QuickStarter(emoji: "💰", title: "Estimate Explanation", desc: "Justify pricing",      prompt: "Write an estimate email for a landscaping project: "),
            QuickStarter(emoji: "📋", title: "Project Timeline",    desc: "Set expectations",      prompt: "Write a project timeline and progress update for: "),
            QuickStarter(emoji: "🛠️", title: "Service Upsell",     desc: "Seasonal offerings",    prompt: "Write about our seasonal landscaping services: "),
        ],
        ideas: [
            IdeaItem(emoji: "🌱", title: "Spring cleanup",        desc: "Seasonal promotion"),
            IdeaItem(emoji: "💡", title: "Lawn care tips",        desc: "Educational content"),
            IdeaItem(emoji: "🏡", title: "Curb appeal guide",     desc: "Drive conversions"),
            IdeaItem(emoji: "🌸", title: "Plant selection",       desc: "Design ideas"),
            IdeaItem(emoji: "⏰", title: "Maintenance schedule",  desc: "Customer retention"),
            IdeaItem(emoji: "🎯", title: "Hardscaping project",   desc: "Upsell opportunities"),
            IdeaItem(emoji: "👥", title: "Testimonial request",   desc: "Social proof"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a helpful assistant for landscaping businesses. Be knowledgeable about outdoor work. Help showcase your team's craftsmanship.",
            "professional": "You are NAGOH AI, a professional business assistant for landscaping companies. Provide clear project communication and credible estimates.",
            "playful":      "You are NAGOH AI, an enthusiastic landscaping assistant. Celebrate beautiful outdoor spaces. Make yard transformation sound exciting.",
            "concise":      "You are NAGOH AI, a landscaping assistant. Be direct about services and pricing. Show value quickly.",
        ]
    ),

    .roofing: IndustryConfig(
        name: "🏠 Roofing & Construction",
        placeholder: "Ask anything — inspections, quotes, safety updates…",
        emptyMsg: "Professional communication for roofing and construction services.",
        quickStarters: [
            QuickStarter(emoji: "🏠", title: "Inspection Report", desc: "Explain findings",        prompt: "Write a roof inspection report explaining: "),
            QuickStarter(emoji: "💰", title: "Quote Letter",       desc: "Professional estimates",  prompt: "Write a roofing project quote for: "),
            QuickStarter(emoji: "⚠️", title: "Safety Notice",     desc: "Job site communication",  prompt: "Write a safety update for our roofing crew: "),
            QuickStarter(emoji: "📅", title: "Project Schedule",   desc: "Timeline management",     prompt: "Write a project timeline email for our roofing job: "),
            QuickStarter(emoji: "✅", title: "Completion Notice",  desc: "Hand-off & warranty",     prompt: "Write a project completion email with warranty info: "),
        ],
        ideas: [
            IdeaItem(emoji: "🔍", title: "Roof inspection tips",  desc: "Educational content"),
            IdeaItem(emoji: "🌧️", title: "Storm damage help",    desc: "Emergency services"),
            IdeaItem(emoji: "📝", title: "Insurance claim guide", desc: "Help customers"),
            IdeaItem(emoji: "⭐", title: "Case study",            desc: "Show your work"),
            IdeaItem(emoji: "🛡️", title: "Warranty explanation", desc: "Peace of mind"),
            IdeaItem(emoji: "💼", title: "Commercial roofing",    desc: "B2B marketing"),
            IdeaItem(emoji: "🎯", title: "Preventive maintenance", desc: "Recurring revenue"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a helpful assistant for roofing contractors. Be reassuring about safety and quality. Build trust with homeowners.",
            "professional": "You are NAGOH AI, a professional business assistant for construction companies. Provide clear, technical communication.",
            "playful":      "You are NAGOH AI, a roofing assistant. Make home protection feel important and manageable.",
            "concise":      "You are NAGOH AI, a roofing assistant. Be direct about problems and solutions.",
        ]
    ),

    .plumbing: IndustryConfig(
        name: "🔧 Plumbing & HVAC",
        placeholder: "Ask anything — emergency calls, repair quotes, maintenance tips…",
        emptyMsg: "Communication tools for plumbing, HVAC, and home services.",
        quickStarters: [
            QuickStarter(emoji: "🚰", title: "Service Description",  desc: "Explain your expertise", prompt: "Write a description of our plumbing/HVAC service: "),
            QuickStarter(emoji: "📞", title: "Emergency Response",   desc: "Quick callback email",   prompt: "Write an emergency service response email: "),
            QuickStarter(emoji: "💰", title: "Service Estimate",     desc: "Professional quotes",    prompt: "Write a service estimate for: "),
            QuickStarter(emoji: "🔧", title: "Maintenance Tips",     desc: "Educational content",    prompt: "Write maintenance tips for homeowners about: "),
            QuickStarter(emoji: "⏰", title: "Appointment Confirm",  desc: "Reduce no-shows",        prompt: "Write an appointment confirmation email: "),
        ],
        ideas: [
            IdeaItem(emoji: "❄️", title: "Winter prep guide",    desc: "Seasonal service"),
            IdeaItem(emoji: "💧", title: "Water saving tips",    desc: "Green marketing"),
            IdeaItem(emoji: "🏠", title: "System maintenance",   desc: "Recurring revenue"),
            IdeaItem(emoji: "🆘", title: "Emergency hotline",    desc: "Highlight availability"),
            IdeaItem(emoji: "📺", title: "Video tutorial",       desc: "Educational content"),
            IdeaItem(emoji: "👥", title: "Customer spotlight",   desc: "Testimonials"),
            IdeaItem(emoji: "🎯", title: "Upgrade options",      desc: "Upsell campaigns"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a helpful assistant for plumbing and HVAC professionals. Be reassuring about home comfort and safety.",
            "professional": "You are NAGOH AI, a professional business assistant for home service companies. Provide clear, technical communication.",
            "playful":      "You are NAGOH AI, a home services assistant. Make plumbing and HVAC feel manageable and important.",
            "concise":      "You are NAGOH AI, a plumbing/HVAC assistant. Be direct and clear. Focus on urgency and solutions.",
        ]
    ),

    .salon: IndustryConfig(
        name: "💇 Hair & Beauty Services",
        placeholder: "Ask anything — services, bookings, product recommendations…",
        emptyMsg: "Marketing and booking tools for salons and beauty services.",
        quickStarters: [
            QuickStarter(emoji: "✨", title: "Service Menu",       desc: "Describe your services", prompt: "Write a description for our salon service: "),
            QuickStarter(emoji: "📸", title: "Transformation Post", desc: "Social media showcase", prompt: "Write a before/after social post for: "),
            QuickStarter(emoji: "💇", title: "Styling Tips",       desc: "Educational content",    prompt: "Write a hair care or styling tip for: "),
            QuickStarter(emoji: "🎁", title: "Gift Card Promo",    desc: "Holiday sales",          prompt: "Write a gift card promotion for our salon: "),
            QuickStarter(emoji: "👑", title: "Special Event",      desc: "Bridal, prom, events",   prompt: "Write about our special occasion services: "),
        ],
        ideas: [
            IdeaItem(emoji: "🌟", title: "New stylist intro",   desc: "Build clientele"),
            IdeaItem(emoji: "💅", title: "Product launch",      desc: "Retail sales"),
            IdeaItem(emoji: "📅", title: "Appointment reminder", desc: "Reduce no-shows"),
            IdeaItem(emoji: "👰", title: "Bridal package",      desc: "Premium service"),
            IdeaItem(emoji: "🎉", title: "Grand opening",       desc: "New location buzz"),
            IdeaItem(emoji: "⭐", title: "Client testimonial",  desc: "Social proof"),
            IdeaItem(emoji: "📱", title: "Social challenge",    desc: "Viral content"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a warm assistant for salons and beauty professionals. Be encouraging and trend-aware.",
            "professional": "You are NAGOH AI, a professional assistant for beauty businesses. Provide polished, brand-consistent messaging.",
            "playful":      "You are NAGOH AI, a fun beauty industry assistant. Use on-trend language and make content feel exciting.",
            "concise":      "You are NAGOH AI, a beauty business assistant. Be snappy and glamorous. Get clients in the chair.",
        ]
    ),

    .photography: IndustryConfig(
        name: "📸 Photography & Creative Services",
        placeholder: "Ask anything — client emails, package descriptions, social content…",
        emptyMsg: "Professional communication for photographers and creative professionals.",
        quickStarters: [
            QuickStarter(emoji: "📸", title: "Package Description", desc: "Sell your services",     prompt: "Write a photography package description for: "),
            QuickStarter(emoji: "💌", title: "Client Inquiry",      desc: "Professional responses", prompt: "Write a response to a photography inquiry: "),
            QuickStarter(emoji: "🎨", title: "Portfolio Post",      desc: "Social media showcase",  prompt: "Write a social media post showcasing my photography of: "),
            QuickStarter(emoji: "💰", title: "Pricing Guide",       desc: "Justify your rates",     prompt: "Write a pricing guide for my photography business: "),
            QuickStarter(emoji: "📅", title: "Booking Confirmation", desc: "Set expectations",      prompt: "Write a booking confirmation email for: "),
        ],
        ideas: [
            IdeaItem(emoji: "🌅", title: "Golden hour session",  desc: "Seasonal promotion"),
            IdeaItem(emoji: "💍", title: "Engagement package",   desc: "Wedding market"),
            IdeaItem(emoji: "👶", title: "Newborn special",      desc: "Family market"),
            IdeaItem(emoji: "🏢", title: "Corporate headshots",  desc: "B2B revenue"),
            IdeaItem(emoji: "📱", title: "Behind the lens",      desc: "Personal brand"),
            IdeaItem(emoji: "⭐", title: "Client review request", desc: "Social proof"),
            IdeaItem(emoji: "🎓", title: "Workshop promo",       desc: "Education revenue"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a creative assistant for photographers. Be enthusiastic about visual storytelling and client relationships.",
            "professional": "You are NAGOH AI, a professional assistant for photographers and creative businesses. Help build a credible, artistic brand.",
            "playful":      "You are NAGOH AI, a fun creative industry assistant. Make photography feel magical and aspirational.",
            "concise":      "You are NAGOH AI, a photography business assistant. Be direct and visually descriptive. Sell the experience.",
        ]
    ),

    .personalTraining: IndustryConfig(
        name: "💪 Personal Training & Fitness",
        placeholder: "Ask anything — programs, client motivation, social content…",
        emptyMsg: "Marketing and coaching tools for fitness professionals.",
        quickStarters: [
            QuickStarter(emoji: "💪", title: "Training Program",   desc: "Custom workout plans",   prompt: "Write a training program description for: "),
            QuickStarter(emoji: "📱", title: "Motivation Post",    desc: "Inspire your clients",   prompt: "Write a motivational fitness post about: "),
            QuickStarter(emoji: "💰", title: "Package Pricing",    desc: "Justify your rates",     prompt: "Write a personal training package offer for: "),
            QuickStarter(emoji: "📊", title: "Progress Update",    desc: "Client check-in",        prompt: "Write a client progress update email: "),
            QuickStarter(emoji: "🏆", title: "Transformation Story", desc: "Social proof",         prompt: "Write a client transformation story: "),
        ],
        ideas: [
            IdeaItem(emoji: "🔥", title: "30-day challenge",    desc: "Build community"),
            IdeaItem(emoji: "🥗", title: "Nutrition tip",       desc: "Value-add content"),
            IdeaItem(emoji: "🧘", title: "Recovery advice",     desc: "Holistic approach"),
            IdeaItem(emoji: "📅", title: "Free trial session",  desc: "Lead generation"),
            IdeaItem(emoji: "🌅", title: "Morning routine",     desc: "Lifestyle branding"),
            IdeaItem(emoji: "⭐", title: "Success story",       desc: "Testimonial request"),
            IdeaItem(emoji: "🎯", title: "Goal setting",        desc: "Client onboarding"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, an encouraging fitness assistant. Be motivating and supportive. Help trainers inspire clients.",
            "professional": "You are NAGOH AI, a professional fitness business assistant. Provide credible, science-backed content.",
            "playful":      "You are NAGOH AI, an energetic fitness assistant. Make working out sound fun and achievable.",
            "concise":      "You are NAGOH AI, a fitness assistant. Be punchy and motivating. Every word counts.",
        ]
    ),

    .insurance: IndustryConfig(
        name: "🛡️ Insurance Agents",
        placeholder: "Ask anything — policy explanations, client follow-ups, prospecting…",
        emptyMsg: "Professional communication for insurance agents and brokers.",
        quickStarters: [
            QuickStarter(emoji: "🛡️", title: "Policy Overview",   desc: "Plain-language summary", prompt: "Write a plain-language explanation of this insurance policy: "),
            QuickStarter(emoji: "💌", title: "Client Follow-up",   desc: "Nurture prospects",      prompt: "Write a follow-up email to a prospect who requested a quote: "),
            QuickStarter(emoji: "📊", title: "Coverage Comparison", desc: "Help clients decide",   prompt: "Write a coverage comparison for these two plans: "),
            QuickStarter(emoji: "📞", title: "Renewal Outreach",   desc: "Keep clients",           prompt: "Write a policy renewal outreach email: "),
            QuickStarter(emoji: "🏆", title: "Referral Request",   desc: "Grow your book",         prompt: "Write a referral request email to a satisfied client: "),
        ],
        ideas: [
            IdeaItem(emoji: "🏠", title: "Home insurance tips",  desc: "Educational content"),
            IdeaItem(emoji: "🚗", title: "Auto policy review",   desc: "Seasonal check-in"),
            IdeaItem(emoji: "👨‍👩‍👧", title: "Life insurance guide", desc: "Family protection"),
            IdeaItem(emoji: "💼", title: "Business coverage",    desc: "Commercial market"),
            IdeaItem(emoji: "📋", title: "Claims walkthrough",   desc: "Client education"),
            IdeaItem(emoji: "⭐", title: "Google review ask",    desc: "Reputation building"),
            IdeaItem(emoji: "🎯", title: "Open enrollment",      desc: "Annual opportunity"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a helpful assistant for insurance agents. Be reassuring and clear. Help clients understand their coverage.",
            "professional": "You are NAGOH AI, a professional insurance industry assistant. Provide compliant, accurate, and persuasive communication.",
            "playful":      "You are NAGOH AI, an insurance assistant. Make a dry topic feel personable and important.",
            "concise":      "You are NAGOH AI, an insurance assistant. Be clear and direct. Remove jargon.",
        ]
    ),

    .consulting: IndustryConfig(
        name: "💼 Consulting & Professional Services",
        placeholder: "Ask anything — proposals, client reports, thought leadership…",
        emptyMsg: "Strategic communication tools for consultants and professionals.",
        quickStarters: [
            QuickStarter(emoji: "📄", title: "Proposal Draft",     desc: "Win new business",       prompt: "Write a consulting proposal for: "),
            QuickStarter(emoji: "📊", title: "Executive Summary",  desc: "Impress stakeholders",   prompt: "Write an executive summary for: "),
            QuickStarter(emoji: "💌", title: "Client Check-in",    desc: "Relationship building",  prompt: "Write a client relationship check-in email: "),
            QuickStarter(emoji: "🎯", title: "Case Study",         desc: "Showcase results",       prompt: "Write a case study for this project: "),
            QuickStarter(emoji: "📅", title: "Project Kickoff",    desc: "Set the tone",           prompt: "Write a project kickoff email for: "),
        ],
        ideas: [
            IdeaItem(emoji: "🧠", title: "Thought leadership",   desc: "LinkedIn article"),
            IdeaItem(emoji: "📈", title: "ROI breakdown",        desc: "Justify your value"),
            IdeaItem(emoji: "🤝", title: "Partnership pitch",    desc: "Strategic alliances"),
            IdeaItem(emoji: "📋", title: "Process improvement",  desc: "Methodology showcase"),
            IdeaItem(emoji: "🎓", title: "Webinar promotion",    desc: "Lead generation"),
            IdeaItem(emoji: "⭐", title: "Client testimonial",   desc: "Social proof"),
            IdeaItem(emoji: "📱", title: "LinkedIn post",        desc: "Professional branding"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a professional assistant for consultants. Be clear and insightful. Help consultants communicate value and build trust.",
            "professional": "You are NAGOH AI, a professional business consultant assistant. Provide strategic, credible, detail-oriented communication.",
            "playful":      "You are NAGOH AI, a consulting assistant. Make complex topics accessible and engaging.",
            "concise":      "You are NAGOH AI, a consulting assistant. Be direct and strategic. Focus on business impact.",
        ]
    ),

    .general: IndustryConfig(
        name: "⭐ General Small Business",
        placeholder: "Ask anything — marketing, customer service, operations…",
        emptyMsg: "Your AI assistant for all small business needs.",
        quickStarters: [
            QuickStarter(emoji: "📝", title: "Product/Service",  desc: "Write descriptions",     prompt: "Write a description for our product/service: "),
            QuickStarter(emoji: "📢", title: "Marketing Post",   desc: "Social media content",   prompt: "Write a social media post for: "),
            QuickStarter(emoji: "💌", title: "Customer Message", desc: "Professional replies",   prompt: "Write a professional response to: "),
            QuickStarter(emoji: "💰", title: "Pricing Strategy", desc: "Fair & profitable",      prompt: "Help me develop pricing for: "),
            QuickStarter(emoji: "📊", title: "Business Plan",    desc: "Growth strategy",        prompt: "Help me create a plan for: "),
        ],
        ideas: [
            IdeaItem(emoji: "📱", title: "Social media post",  desc: "Build audience"),
            IdeaItem(emoji: "📧", title: "Email campaign",     desc: "Customer retention"),
            IdeaItem(emoji: "🎯", title: "Lead generation",    desc: "Grow your business"),
            IdeaItem(emoji: "⭐", title: "Customer review",    desc: "Request testimonials"),
            IdeaItem(emoji: "🎁", title: "Promotion idea",     desc: "Drive sales"),
            IdeaItem(emoji: "📞", title: "Cold outreach",      desc: "New business"),
            IdeaItem(emoji: "🎉", title: "Event planning",     desc: "Customer engagement"),
        ],
        tonePrompts: [
            "friendly":     "You are NAGOH AI, a warm and practical assistant for small business owners. Be supportive and encouraging. Help entrepreneurs succeed.",
            "professional": "You are NAGOH AI, a professional business assistant. Provide clear, strategic business advice.",
            "playful":      "You are NAGOH AI, an enthusiastic business assistant. Make entrepreneurship feel exciting and achievable.",
            "concise":      "You are NAGOH AI, a business assistant. Be direct and actionable. Focus on results.",
        ]
    ),
]
