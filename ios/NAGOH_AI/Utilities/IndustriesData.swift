import Foundation

// MARK: – Industry enum

enum Industry: String, CaseIterable, Identifiable, Codable {
    case etsy
    case realtor
    case landlord
    case coffee
    case salon
    case photography
    case consulting
    case general

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .etsy:         return "🛍️ Etsy Sellers"
        case .realtor:      return "🏠 Real Estate"
        case .landlord:     return "🏘️ Landlords"
        case .coffee:       return "☕ Coffee Shop"
        case .salon:        return "💇 Salon & Beauty"
        case .photography:  return "📸 Photography"
        case .consulting:   return "💼 Consulting"
        case .general:      return "⭐ General Business"
        }
    }

    var emoji: String {
        switch self {
        case .etsy:         return "🛍️"
        case .realtor:      return "🏠"
        case .landlord:     return "🏘️"
        case .coffee:       return "☕"
        case .salon:        return "💇"
        case .photography:  return "📸"
        case .consulting:   return "💼"
        case .general:      return "⭐"
        }
    }

    var placeholder: String {
        switch self {
        case .etsy:         return "Ask anything — listing copy, captions, pricing, customer replies…"
        case .realtor:      return "Ask anything — listings, social posts, client follow-ups…"
        case .landlord:     return "Ask anything — lease clauses, tenant notices, maintenance…"
        case .coffee:       return "Ask anything — menu copy, Instagram posts, promotions…"
        case .salon:        return "Ask anything — booking copy, social posts, promotions…"
        case .photography:  return "Ask anything — client emails, captions, packages…"
        case .consulting:   return "Ask anything — proposals, reports, client communication…"
        case .general:      return "Ask anything — marketing, customer service, operations…"
        }
    }

    var systemPrompt: String {
        switch self {
        case .etsy:
            return "You are NAGOH AI, a warm, encouraging assistant for Etsy sellers, crafters, and artists. Be supportive and clear. Use simple language. Help them feel confident about their business and creative work."
        case .realtor:
            return "You are NAGOH AI, a helpful assistant for real estate professionals. Be warm, professional, and client-focused. Create content that builds trust and showcases properties effectively."
        case .landlord:
            return "You are NAGOH AI, a professional assistant for landlords and property managers. Provide clear, legally-aware communication templates while remaining approachable."
        case .coffee:
            return "You are NAGOH AI, an enthusiastic assistant for coffee shop owners. Be warm and inviting, helping craft content that reflects the cozy community vibe of a great coffee shop."
        case .salon:
            return "You are NAGOH AI, a friendly assistant for salon and beauty professionals. Help create content that makes clients feel pampered and excited to book appointments."
        case .photography:
            return "You are NAGOH AI, a creative assistant for photographers. Help craft compelling content that showcases their artistry and attracts ideal clients."
        case .consulting:
            return "You are NAGOH AI, a professional business assistant for consultants. Provide polished, credibility-building content that positions them as trusted experts."
        case .general:
            return "You are NAGOH AI, a warm and practical assistant for small business owners. Be supportive and encouraging. Help entrepreneurs succeed."
        }
    }

    var quickStarters: [QuickStarter] {
        switch self {
        case .etsy:
            return [
                QuickStarter(emoji: "📝", title: "Product Listing",  description: "Write descriptions that sell",  prompt: "Write an Etsy product description for: "),
                QuickStarter(emoji: "📸", title: "Social Captions",  description: "Instagram, Facebook & more",   prompt: "Write 5 Instagram captions for my craft shop that sells: "),
                QuickStarter(emoji: "💌", title: "Customer Reply",   description: "Handle messages with ease",    prompt: "Write a friendly reply to this customer message: "),
                QuickStarter(emoji: "💰", title: "Pricing Help",     description: "Price your work fairly",       prompt: "Give me 10 pricing strategies for my craft business that makes: "),
                QuickStarter(emoji: "🔍", title: "SEO & Tags",       description: "Get found by buyers",          prompt: "Write SEO tags and keywords for my Etsy shop that sells: "),
            ]
        case .realtor:
            return [
                QuickStarter(emoji: "🏘️", title: "Property Listing",  description: "MLS-ready descriptions",     prompt: "Write a compelling real estate listing description for: "),
                QuickStarter(emoji: "📸", title: "Social Post",        description: "Facebook, Instagram ads",    prompt: "Write a social media post to promote this property: "),
                QuickStarter(emoji: "💌", title: "Client Follow-up",   description: "Nurture leads",              prompt: "Write a follow-up email to a client who viewed this property: "),
                QuickStarter(emoji: "📊", title: "Market Analysis",    description: "Explain neighborhood value", prompt: "Write a market analysis summary for this neighborhood: "),
                QuickStarter(emoji: "🎯", title: "Open House Invite",  description: "Drive attendance",           prompt: "Write an open house invitation email for: "),
            ]
        case .landlord:
            return [
                QuickStarter(emoji: "📋", title: "Lease Clause",     description: "Professional lease language",  prompt: "Write a lease clause for: "),
                QuickStarter(emoji: "📬", title: "Tenant Notice",    description: "Formal notices",               prompt: "Write a professional tenant notice about: "),
                QuickStarter(emoji: "🔧", title: "Maintenance Reply", description: "Handle repair requests",      prompt: "Write a maintenance response for this tenant request: "),
                QuickStarter(emoji: "🏠", title: "Listing Copy",     description: "Attract quality tenants",      prompt: "Write a rental listing for this property: "),
                QuickStarter(emoji: "💰", title: "Rent Increase",    description: "Professional rent notice",     prompt: "Write a professional rent increase notice for: "),
            ]
        case .coffee:
            return [
                QuickStarter(emoji: "☕", title: "Menu Description", description: "Make drinks sound irresistible", prompt: "Write a menu description for: "),
                QuickStarter(emoji: "📱", title: "Instagram Post",   description: "Cozy café content",             prompt: "Write an Instagram post for my coffee shop about: "),
                QuickStarter(emoji: "🎉", title: "Special Offer",    description: "Promotions & deals",            prompt: "Write a promotional post for: "),
                QuickStarter(emoji: "🌟", title: "Review Reply",     description: "Respond to customers",          prompt: "Write a warm reply to this review: "),
                QuickStarter(emoji: "📧", title: "Email Newsletter", description: "Loyal customer updates",        prompt: "Write an email newsletter for my coffee shop about: "),
            ]
        case .salon:
            return [
                QuickStarter(emoji: "💇", title: "Service Description", description: "Make services sound luxurious", prompt: "Write a service description for: "),
                QuickStarter(emoji: "📱", title: "Instagram Post",      description: "Beauty content that books",     prompt: "Write an Instagram caption for my salon post about: "),
                QuickStarter(emoji: "📅", title: "Booking Reminder",    description: "Reduce no-shows",               prompt: "Write a booking reminder message for: "),
                QuickStarter(emoji: "🎁", title: "Promo Offer",         description: "Fill your calendar",            prompt: "Write a promotional offer for: "),
                QuickStarter(emoji: "💌", title: "Client Follow-up",    description: "Build loyalty",                 prompt: "Write a follow-up message to a client after their appointment for: "),
            ]
        case .photography:
            return [
                QuickStarter(emoji: "📸", title: "Package Description", description: "Sell your photography packages", prompt: "Write a photography package description for: "),
                QuickStarter(emoji: "💌", title: "Client Email",         description: "Professional client communication", prompt: "Write a client email about: "),
                QuickStarter(emoji: "📱", title: "Instagram Caption",    description: "Showcase your work",              prompt: "Write an Instagram caption for my photography post about: "),
                QuickStarter(emoji: "🎯", title: "Inquiry Reply",        description: "Win new clients",                 prompt: "Write a reply to a photography inquiry about: "),
                QuickStarter(emoji: "⭐", title: "Testimonial Request",  description: "Get more reviews",                prompt: "Write a message asking for a testimonial from: "),
            ]
        case .consulting:
            return [
                QuickStarter(emoji: "📋", title: "Proposal",          description: "Win new business",          prompt: "Write a consulting proposal for: "),
                QuickStarter(emoji: "📊", title: "Executive Summary",  description: "Clear, concise reporting",  prompt: "Write an executive summary for: "),
                QuickStarter(emoji: "💌", title: "Client Update",      description: "Keep clients informed",     prompt: "Write a client project update for: "),
                QuickStarter(emoji: "🎯", title: "Case Study",         description: "Show your results",         prompt: "Write a case study for: "),
                QuickStarter(emoji: "🤝", title: "Outreach Email",     description: "Land new clients",          prompt: "Write a cold outreach email for: "),
            ]
        case .general:
            return [
                QuickStarter(emoji: "📝", title: "Product/Service",   description: "Write descriptions",           prompt: "Write a description for our product/service: "),
                QuickStarter(emoji: "📢", title: "Marketing Post",    description: "Social media content",         prompt: "Write a social media post for: "),
                QuickStarter(emoji: "💌", title: "Customer Message",  description: "Professional replies",         prompt: "Write a professional response to: "),
                QuickStarter(emoji: "💰", title: "Pricing Strategy",  description: "Fair & profitable",            prompt: "Help me develop pricing for: "),
                QuickStarter(emoji: "📊", title: "Business Plan",     description: "Growth strategy",              prompt: "Help me create a plan for: "),
            ]
        }
    }
}

struct QuickStarter: Identifiable {
    var id: String { title }
    let emoji: String
    let title: String
    let description: String
    let prompt: String
}

// MARK: – Templates per industry

extension Industry {
    var templates: [AppTemplate] {
        switch self {
        case .etsy:
            return [
                AppTemplate(
                    id: "etsy_listing",
                    emoji: "🛍️",
                    title: "Product Listing",
                    description: "SEO-optimized listing copy",
                    content: """
PRODUCT TITLE: [Clear, searchable title with key words]

SHORT DESCRIPTION: [1-2 sentences, benefit-focused]

FULL DESCRIPTION:
What it is: [Simple, clear description of the item]

Materials: [List all materials used]

Dimensions: [Size/specifications]

Care Instructions: [How to care for it]

Made to Order Note: [If applicable, timeline]

Perfect For: [Who would love this? Gift ideas?]

TAGS: [12 relevant, searchable tags]
""",
                    industry: .etsy
                ),
                AppTemplate(
                    id: "etsy_instagram",
                    emoji: "📸",
                    title: "Instagram Caption",
                    description: "Drive traffic to your shop",
                    content: """
[Hook - stop the scroll]

🎨 What: [What is this product?]
💎 Why: [Why is it special/unique?]
🛍️ Where: [Link to shop/product]

[3-5 relevant hashtags]
[Brand hashtags]
""",
                    industry: .etsy
                ),
                AppTemplate(
                    id: "etsy_customer_reply",
                    emoji: "💌",
                    title: "Customer Reply Template",
                    description: "Warm, professional replies",
                    content: """
Hi [Customer Name],

Thank you so much for reaching out! 

[Address their specific question/concern clearly]

[Offer solution or next steps]

Please don't hesitate to message me if you have any other questions. I'm happy to help!

Warm regards,
[Your Shop Name]
""",
                    industry: .etsy
                ),
            ]
        case .realtor:
            return [
                AppTemplate(
                    id: "realtor_listing",
                    emoji: "🏘️",
                    title: "Property Listing",
                    description: "MLS-ready property description",
                    content: """
PROPERTY ADDRESS: [Full address]

HEADLINE: [Compelling 1-line description]

DESCRIPTION:
Welcome to [brief property highlight]. This [style] home features [key features].

HIGHLIGHTS:
• [Bedrooms/Bathrooms]
• [Key features - kitchen, yard, garage, etc.]
• [Location benefits - school district, walkability, etc.]
• [Recent updates/renovations]
• [Unique selling points]

NEIGHBORHOOD: [What makes this location special]

CALL TO ACTION: Schedule your private showing today. This one won't last!
""",
                    industry: .realtor
                ),
                AppTemplate(
                    id: "realtor_social",
                    emoji: "📸",
                    title: "Social Media Post",
                    description: "Property promotion for social",
                    content: """
🏡 JUST LISTED! [Address]

[Compelling property highlight in 1-2 sentences]

✅ [Bedrooms] Beds / [Bathrooms] Baths
✅ [Key feature 1]
✅ [Key feature 2]
✅ [Price] — [Value statement]

📍 [Neighborhood/Area]

DM me for details or to schedule a showing!

[Contact info]
#[City]RealEstate #JustListed #[Neighborhood] #HomesForSale
""",
                    industry: .realtor
                ),
            ]
        default:
            return [
                AppTemplate(
                    id: "\(rawValue)_social",
                    emoji: "📱",
                    title: "Social Media Post",
                    description: "Engaging social content",
                    content: """
[Hook that grabs attention]

[Value-packed content in 2-3 lines]

[Call to action]

[3-5 relevant hashtags]
""",
                    industry: self
                ),
                AppTemplate(
                    id: "\(rawValue)_email",
                    emoji: "📧",
                    title: "Email Campaign",
                    description: "Customer email template",
                    content: """
Subject: [Compelling subject line]

Hi [First Name],

[Opening that addresses their pain point or interest]

[Key message — keep it focused and valuable]

[Clear call to action — one action only]

[Sign off]
[Your name]
[Business name]
""",
                    industry: self
                ),
            ]
        }
    }

    var strategyPrompts: [StrategyPrompt] {
        return [
            StrategyPrompt(
                id: "\(rawValue)_strategy_1",
                emoji: "🗓️",
                title: "30-Day Content Plan",
                description: "Never run out of ideas",
                prompt: "Create a 30-day social media content plan for my \(displayName) business. Mix educational, promotional, and engaging posts.",
                industry: self
            ),
            StrategyPrompt(
                id: "\(rawValue)_strategy_2",
                emoji: "🎯",
                title: "Content Pillars",
                description: "Build a consistent brand voice",
                prompt: "Define 5 content pillars for my \(displayName) business. For each pillar, give me 3 post ideas.",
                industry: self
            ),
            StrategyPrompt(
                id: "\(rawValue)_strategy_3",
                emoji: "📈",
                title: "Engagement Boosters",
                description: "Grow your audience",
                prompt: "Give me 10 engagement-boosting post ideas for my \(displayName) business. Focus on content that drives comments and shares.",
                industry: self
            ),
        ]
    }
}
