// ═════════════════════════════════════════════════════════════════════════════
// NAGOH AI — Shared Utilities & Constants
// ═════════════════════════════════════════════════════════════════════════════

const WORKER = 'https://nagohai.gregoryhogan.workers.dev';
const GOOGLE_CLIENT_ID = '571680874030-4o2cr62ghese6d6r4e79m9gqj7vhsr9f.apps.googleusercontent.com';
const STRIPE_PUBLISHABLE_KEY = 'pk_live_51TK0JWGUbXtKf7F7FBt5ingZaPPj8oi6n7sk50AS4yWKkoISv6bJHXphJS5ygOX0QQScFuDUskZ6Uq0SCgwBVwnr00GVEiex2f';

const INDUSTRIES = {
  etsy: {
    name: '🛍️ Etsy & Craft Sellers',
    placeholder: 'Ask anything — listing copy, captions, pricing, customer replies…',
    emptyMsg: 'Perfect for selling handmade goods, crafts, and creative items.',
    quickStarters: [
      { emoji: '📝', title: 'Product Listing', desc: 'Write descriptions that sell', prompt: 'Write an Etsy product description for: ' },
      { emoji: '📸', title: 'Social Captions', desc: 'Instagram, Facebook & more', prompt: 'Write 5 Instagram captions for my craft shop that sells: ' },
      { emoji: '💌', title: 'Customer Reply', desc: 'Handle messages with ease', prompt: 'Write a friendly reply to this customer message: ' },
      { emoji: '💰', title: 'Pricing Help', desc: 'Price your work fairly', prompt: 'Give me 10 pricing strategies for my craft business that makes: ' },
      { emoji: '🔍', title: 'SEO & Tags', desc: 'Get found by buyers', prompt: 'Write SEO tags and keywords for my Etsy shop that sells: ' },
    ],
    ideas: [
      { emoji: '🎄', title: 'Holiday announcement', desc: 'Let buyers know your hours' },
      { emoji: '📅', title: 'Weekly content plan', desc: 'Never run out of post ideas' },
      { emoji: '💝', title: 'Thank-you note', desc: 'Delight your customers' },
      { emoji: '🔎', title: 'Trending keywords', desc: 'Improve your SEO' },
      { emoji: '🛡️', title: 'Handle bad reviews', desc: 'Respond with grace' },
      { emoji: '🗓️', title: '30-day social plan', desc: 'Stay consistent online' },
      { emoji: '📦', title: 'Shipping tips', desc: 'Keep buyers happy' },
    ],
    tonePrompts: {
      friendly: "You are NAGOH AI, a warm, encouraging assistant for Etsy sellers, crafters, and artists. Be supportive and clear. Use simple language.",
      professional: "You are NAGOH AI, a professional business assistant for Etsy sellers. Provide clear, well-structured advice about listings, pricing, and customer service.",
      playful: "You are NAGOH AI, a fun and enthusiastic assistant for creative makers! Be upbeat and make running a craft business feel exciting.",
      concise: "You are NAGOH AI, an assistant for Etsy sellers. Be extremely concise. Bullet points preferred. No fluff.",
    }
  },
  realtor: {
    name: '🏠 Real Estate Agents',
    placeholder: 'Ask anything — listings, social posts, client follow-ups, property promotions…',
    emptyMsg: 'Create professional property listings and marketing content.',
    quickStarters: [
      { emoji: '🏘️', title: 'Property Listing', desc: 'MLS-ready descriptions', prompt: 'Write a compelling real estate listing description: ' },
      { emoji: '📸', title: 'Social Post', desc: 'Facebook, Instagram ads', prompt: 'Write a social media post to promote this property: ' },
      { emoji: '💌', title: 'Client Follow-up', desc: 'Nurture leads', prompt: 'Write a follow-up email to a client: ' },
      { emoji: '📊', title: 'Market Analysis', desc: 'Explain neighborhood value', prompt: 'Write a market analysis summary for this neighborhood: ' },
      { emoji: '🎯', title: 'Open House Invite', desc: 'Drive attendance', prompt: 'Write an open house invitation email: ' },
    ],
    ideas: [
      { emoji: '🏡', title: 'New listing announcement', desc: 'Alert your sphere' },
      { emoji: '📍', title: 'Neighborhood guide', desc: 'Show local value' },
      { emoji: '💼', title: 'Buyer qualification', desc: 'Pre-qualify leads' },
      { emoji: '🔑', title: 'Closing congrats', desc: 'Build relationships' },
      { emoji: '🏆', title: 'Success story', desc: 'Share testimonials' },
      { emoji: '💡', title: 'Investment tips', desc: 'Attract investors' },
      { emoji: '📞', title: 'Cold outreach', desc: 'Expired/FSBO scripts' },
    ],
    tonePrompts: {
      friendly: "You are NAGOH AI, a helpful assistant for real estate professionals. Be warm, professional, and client-focused.",
      professional: "You are NAGOH AI, a professional real estate assistant. Provide clear, market-smart advice.",
      playful: "You are NAGOH AI, an enthusiastic real estate marketing assistant. Be energetic and engaging.",
      concise: "You are NAGOH AI, a real estate assistant. Be concise and direct.",
    }
  },
  general: {
    name: '⭐ General Small Business',
    placeholder: 'Ask anything — marketing, customer service, operations…',
    emptyMsg: 'Your AI assistant for all small business needs.',
    quickStarters: [
      { emoji: '📝', title: 'Product/Service', desc: 'Write descriptions', prompt: 'Write a description for our product/service: ' },
      { emoji: '📢', title: 'Marketing Post', desc: 'Social media content', prompt: 'Write a social media post for: ' },
      { emoji: '💌', title: 'Customer Message', desc: 'Professional replies', prompt: 'Write a professional response to: ' },
      { emoji: '💰', title: 'Pricing Strategy', desc: 'Fair & profitable', prompt: 'Help me develop pricing for: ' },
      { emoji: '📊', title: 'Business Plan', desc: 'Growth strategy', prompt: 'Help me create a plan for: ' },
    ],
    ideas: [
      { emoji: '📱', title: 'Social media post', desc: 'Build audience' },
      { emoji: '📧', title: 'Email campaign', desc: 'Customer retention' },
      { emoji: '🎯', title: 'Lead generation', desc: 'Grow your business' },
      { emoji: '⭐', title: 'Customer review', desc: 'Request testimonials' },
      { emoji: '🎁', title: 'Promotion idea', desc: 'Drive sales' },
      { emoji: '📞', title: 'Cold outreach', desc: 'New business' },
      { emoji: '🎉', title: 'Event planning', desc: 'Customer engagement' },
    ],
    tonePrompts: {
      friendly: "You are NAGOH AI, a warm and practical assistant for small business owners. Be supportive and encouraging.",
      professional: "You are NAGOH AI, a professional business assistant. Provide clear, strategic advice.",
      playful: "You are NAGOH AI, an enthusiastic business assistant. Make entrepreneurship feel exciting.",
      concise: "You are NAGOH AI, a business assistant. Be direct and actionable.",
    }
  }
};

const INDUSTRY_TRENDING = {
  ecommerce: [
    { title: 'Post-Purchase Sequences', emoji: '📧', momentum: 'trending', context: 'Follow-up emails drive repeat purchases by 40%.' },
    { title: 'User-Generated Content', emoji: '📸', momentum: 'viral', context: 'Customer photos get 5-10x higher engagement.' },
    { title: 'Seasonal Flash Sales', emoji: '⚡', momentum: 'trending', context: 'Limited-time offers create urgency and drive conversions.' },
    { title: 'Sustainable Packaging', emoji: '♻️', momentum: 'rising', context: 'Eco-friendly materials appeal to conscious consumers.' },
    { title: 'Video Product Demos', emoji: '🎬', momentum: 'trending', context: 'Short videos convert 300% better than static images.' },
  ],
  general: [
    { title: 'Personal Brand Stories', emoji: '👤', momentum: 'trending', context: 'Personal narratives build stronger audience connections.' },
    { title: 'Quick Tips & Hacks', emoji: '⚡', momentum: 'evergreen', context: 'Short-form educational content always performs well.' },
    { title: 'Industry Predictions', emoji: '🔮', momentum: 'trending', context: 'Forward-looking insights establish thought leadership.' },
    { title: 'Community Engagement', emoji: '🤝', momentum: 'steady', context: 'Interactive content drives 2x more engagement.' },
    { title: 'Educational Guides', emoji: '📚', momentum: 'evergreen', context: 'How-to content has the longest lifespan.' },
  ]
};

// Session state
let sessionToken = '';
let currentUser = null;
let isGuest = false;
let balance = 0;
let currentIndustry = 'etsy';

function getSession() {
  const sessionStored = sessionStorage.getItem('nagoh_session');
  const localStored = localStorage.getItem('nagoh_session');
  const saved = sessionStored || localStored;
  if (saved) {
    try {
      const parsed = JSON.parse(saved);
      sessionToken = parsed.token;
      currentUser = parsed.user;
      balance = parsed.balance || 0;
      return true;
    } catch { return false; }
  }
  return false;
}

function saveSession(token, user, bal) {
  sessionToken = token;
  currentUser = user;
  balance = bal;
  const sessionData = { token, user, balance: bal };
  sessionStorage.setItem('nagoh_session', JSON.stringify(sessionData));
  localStorage.setItem('nagoh_session', JSON.stringify(sessionData));
}

function clearSession() {
  sessionToken = '';
  currentUser = null;
  isGuest = false;
  sessionStorage.removeItem('nagoh_session');
  localStorage.removeItem('nagoh_session');
}

function isLoggedIn() {
  return !!sessionToken && !!currentUser;
}

// API calls
async function handleGoogleCredential(response) {
  if (!response || !response.credential) return { error: 'Sign-in cancelled.' };
  try {
    const r = await fetch(`${WORKER}/v1/auth/google`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id_token: response.credential }),
    });
    const d = await r.json();
    if (!r.ok) throw new Error(d.error || 'Auth failed');
    saveSession(d.session_token, d.user, d.token_balance);
    return { success: true, user: d.user, balance: d.token_balance };
  } catch (err) {
    return { error: err.message || 'Sign-in failed.' };
  }
}

async function guestAuth() {
  try {
    const r = await fetch(`${WORKER}/v1/auth/guest`, { method: 'POST' });
    const d = await r.json();
    if (d.session_token) {
      saveSession(d.session_token, d.user, d.token_balance);
      isGuest = true;
      return { success: true, user: d.user, balance: d.token_balance };
    }
  } catch (err) {
    return { error: err.message };
  }
}

async function getBalance() {
  try {
    const r = await fetch(`${WORKER}/v1/balance`, {
      headers: { 'Authorization': `Bearer ${sessionToken}` }
    });
    const d = await r.json();
    if (!r.ok) throw new Error(d.error);
    balance = d.token_balance;
    return d;
  } catch (err) {
    return { error: err.message };
  }
}

async function sendChat(messages, systemPrompt, model = 'deepseek-chat') {
  try {
    const r = await fetch(`${WORKER}/v1/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${sessionToken}`,
      },
      body: JSON.stringify({ messages, system: systemPrompt, model, max_tokens: 2048, temperature: 0.75 }),
    });
    const data = await r.json();
    if (!r.ok) return { error: data.error || 'API error', status: r.status };
    balance = data.nagoh.tokens_remaining;
    return { success: true, reply: data.message.content, nagoh: data.nagoh };
  } catch (err) {
    return { error: err.message };
  }
}

async function trackAnalytic(event, data = {}) {
  try {
    await fetch(`${WORKER}/v1/analytics/track`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${sessionToken}`,
      },
      body: JSON.stringify({ event, ...data }),
    });
  } catch (err) {
    console.error('Analytics error:', err);
  }
}

async function getAnalyticsDashboard(period = 'week') {
  try {
    const r = await fetch(`${WORKER}/v1/analytics/dashboard?period=${period}`, {
      headers: { 'Authorization': `Bearer ${sessionToken}` }
    });
    const d = await r.json();
    if (!r.ok) throw new Error(d.error);
    return d;
  } catch (err) {
    return { error: err.message };
  }
}

async function getTrendingTopics() {
  try {
    const r = await fetch(`${WORKER}/v1/trending`, {
      headers: { 'Authorization': `Bearer ${sessionToken}` }
    });
    const d = await r.json();
    if (!r.ok) throw new Error(d.error);
    return d;
  } catch (err) {
    return { error: err.message };
  }
}

async function generateQuote(clientName, service, scope, budget, details = '') {
  try {
    const r = await fetch(`${WORKER}/v1/quotes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${sessionToken}`,
      },
      body: JSON.stringify({ client_name: clientName, service, scope, budget, details }),
    });
    const d = await r.json();
    if (!r.ok) throw new Error(d.error);
    return { quote: d.quote };
  } catch (err) {
    return { error: err.message };
  }
}

async function getSuggestions(content, type = 'general') {
  try {
    const r = await fetch(`${WORKER}/v1/suggestions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${sessionToken}`,
      },
      body: JSON.stringify({ content, type }),
    });
    const d = await r.json();
    if (!r.ok) throw new Error(d.error);
    return d;
  } catch (err) {
    return { error: err.message };
  }
}

// Local storage helpers
function lsSet(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch {} }
function lsGet(k, d) { try { const v = localStorage.getItem(k); return v ? JSON.parse(v) : d; } catch { return d; } }
function lsDel(k) { try { localStorage.removeItem(k); } catch {} }

// UI helpers
function showSuccessNotification(msg) {
  const banner = document.getElementById('successBanner');
  if (banner) {
    document.getElementById('successMsg').textContent = msg;
    banner.classList.add('show');
    setTimeout(() => banner.classList.remove('show'), 4000);
  }
}

function esc(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function setBalUI(n) {
  const fmt = n.toLocaleString();
  const balNum = document.getElementById('balNum');
  const topBal = document.getElementById('topBal');
  if (balNum) balNum.textContent = fmt;
  if (topBal) topBal.innerHTML = `${fmt} <span>tokens</span>`;
}

function initGoogle() {
  if (typeof google !== 'undefined') {
    google.accounts.id.initialize({
      client_id: GOOGLE_CLIENT_ID,
      callback: async (response) => {
        const result = await handleGoogleCredential(response);
        if (result.success && window.onGoogleSignIn) window.onGoogleSignIn(result);
        else if (result.error && window.onGoogleSignInError) window.onGoogleSignInError(result.error);
      },
      auto_select: false,
      cancel_on_tap_outside: false,
    });
  }
}

document.addEventListener('DOMContentLoaded', initGoogle);
