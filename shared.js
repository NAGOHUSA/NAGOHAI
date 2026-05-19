// ═════════════════════════════════════════════════════════════════════════════
// NAGOH AI — Shared Utilities, Config & API Calls (FIXED)
// ═════════════════════════════════════════════════════════════════════════════

// Configuration
const WORKER = 'https://nagohai.gregoryhogan.workers.dev';
const GOOGLE_CLIENT_ID = '571680874030-4o2cr62ghese6d6r4e79m9gqj7vhsr9f.apps.googleusercontent.com';
const STRIPE_PUBLISHABLE_KEY = 'pk_live_51TK0JWGUbXtKf7F7FBt5ingZaPPj8oi6n7sk50AS4yWKkoISv6bJHXphJS5ygOX0QQScFuDUskZ6Uq0SCgwBVwnr00GVEiex2f';

// Industry-specific configurations
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
      friendly: "You are NAGOH AI, a warm, encouraging assistant for Etsy sellers, crafters, and artists. Be supportive and clear. Use simple language. Help them feel confident about their business and creative work.",
      professional: "You are NAGOH AI, a professional business assistant for Etsy sellers. Provide clear, well-structured advice about listings, pricing, and customer service.",
      playful: "You are NAGOH AI, a fun and enthusiastic assistant for creative makers! Be upbeat and make running a craft business feel exciting. Use emojis occasionally.",
      concise: "You are NAGOH AI, an assistant for Etsy sellers. Be extremely concise. Bullet points preferred. No fluff.",
    }
  },
  realtor: {
    name: '🏠 Real Estate Agents',
    placeholder: 'Ask anything — listings, social posts, client follow-ups, property promotions…',
    emptyMsg: 'Create professional property listings and marketing content.',
    quickStarters: [
      { emoji: '🏘️', title: 'Property Listing', desc: 'MLS-ready descriptions', prompt: 'Write a compelling real estate listing description for a house at [address/MLS number]: ' },
      { emoji: '📸', title: 'Social Post', desc: 'Facebook, Instagram ads', prompt: 'Write a social media post to promote this property: [address]: ' },
      { emoji: '💌', title: 'Client Follow-up', desc: 'Nurture leads', prompt: 'Write a follow-up email to a client who viewed this property: ' },
      { emoji: '📊', title: 'Market Analysis', desc: 'Explain neighborhood value', prompt: 'Write a market analysis summary for this neighborhood: ' },
      { emoji: '🎯', title: 'Open House Invite', desc: 'Drive attendance', prompt: 'Write an open house invitation email for: ' },
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
      friendly: "You are NAGOH AI, a helpful assistant for real estate professionals. Be warm, professional, and client-focused. Create content that builds trust and showcases properties effectively.",
      professional: "You are NAGOH AI, a professional real estate assistant. Provide clear, market-smart advice about listings, marketing, and client management.",
      playful: "You are NAGOH AI, an enthusiastic real estate marketing assistant. Be energetic and make property marketing fun and engaging.",
      concise: "You are NAGOH AI, a real estate assistant. Be concise and direct. Focus on key selling points and call-to-action.",
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
      friendly: "You are NAGOH AI, a warm and practical assistant for small business owners. Be supportive and encouraging. Help entrepreneurs succeed.",
      professional: "You are NAGOH AI, a professional business assistant. Provide clear, strategic business advice.",
      playful: "You are NAGOH AI, an enthusiastic business assistant. Make entrepreneurship feel exciting and achievable.",
      concise: "You are NAGOH AI, a business assistant. Be direct and actionable. Focus on results.",
    }
  }
};

// Trending topics
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

// Global state
let sessionToken = '';
let currentUser = null;
let isGuest = false;
let balance = 0;
let currentIndustry = 'etsy';

// ─────────────────────────────────────────────────────────
// SESSION MANAGEMENT
// ─────────────────────────────────────────────────────────

function saveSession(token, user, bal) {
  sessionToken = token;
  currentUser = user;
  balance = bal;
  const sessionData = { token, user, balance: bal };
  sessionStorage.setItem('nagoh_session', JSON.stringify(sessionData));
  localStorage.setItem('nagoh_session', JSON.stringify(sessionData));
}

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
    } catch {
      return false;
    }
  }
  return false;
}

function clearSession() {
  sessionToken = '';
  currentUser = null;
  isGuest = false;
  sessionStorage.removeItem('nagoh_session');
  localStorage.removeItem('nagoh_session');
}

// ─────────────────────────────────────────────────────────
// API CALLS
// ─────────────────────────────────────────────────────────

async function callAPI(endpoint, method = 'GET', body = null) {
  const options = {
    method,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${sessionToken}`,
    }
  };
  if (body) options.body = JSON.stringify(body);
  
  try {
    const r = await fetch(`${WORKER}${endpoint}`, options);
    const d = await r.json();
    return { ok: r.ok, status: r.status, data: d };
  } catch (e) {
    return { ok: false, status: 0, error: e.message };
  }
}

async function sendChat(messages, systemPrompt, model = 'deepseek-chat') {
  return await callAPI('/v1/chat', 'POST', {
    messages,
    system: systemPrompt,
    model,
    max_tokens: 2048,
    temperature: 0.75,
  });
}

async function getBalance() {
  const result = await callAPI('/v1/balance');
  if (result.ok) balance = result.data.token_balance;
  return result;
}

async function authGoogle(idToken) {
  return await callAPI('/v1/auth/google', 'POST', { id_token: idToken });
}

async function authGuest() {
  return await callAPI('/v1/auth/guest', 'POST', {});
}

// ─────────────────────────────────────────────────────────
// LOCAL STORAGE HELPERS
// ─────────────────────────────────────────────────────────

function lsSet(k, v) { 
  try { localStorage.setItem(k, JSON.stringify(v)); } catch {} 
}

function lsGet(k, d) { 
  try { 
    const v = localStorage.getItem(k); 
    return v ? JSON.parse(v) : d; 
  } catch { 
    return d; 
  } 
}

// ─────────────────────────────────────────────────────────
// UI HELPERS
// ─────────────────────────────────────────────────────────

function esc(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function showSuccessNotification(msg) {
  const banner = document.getElementById('successBanner');
  if (banner) {
    document.getElementById('successMsg').textContent = msg;
    banner.classList.add('show');
    setTimeout(() => {
      banner.classList.remove('show');
    }, 4000);
  }
}

function setLed(state, label) {
  const led = document.getElementById('led');
  const sstr = document.getElementById('sstr');
  if (led) led.className = 'dot ' + state;
  if (sstr) sstr.textContent = label;
}

function setBalUI(n) {
  const fmt = n.toLocaleString();
  const balNum = document.getElementById('balNum');
  const topBal = document.getElementById('topBal');
  if (balNum) balNum.textContent = fmt;
  if (topBal) topBal.innerHTML = `${fmt} <span>tokens</span>`;
}

function applyUserToUI(user) {
  if (!user) return;
  const avatar = document.getElementById('tuserAvatar');
  const name = document.getElementById('tuserName');
  if (user.picture && avatar) { avatar.src = user.picture; avatar.classList.add('show'); }
  if (user.name && name) { name.textContent = user.name.split(' ')[0]; name.classList.add('show'); }
  
  // Update subscription tier UI if function exists
  if (typeof updateTierUI === 'function') {
    updateTierUI();
  }
}

function showModal() {
  const modal = document.getElementById('modalWrap');
  if (modal) modal.classList.remove('hidden');
}

function hideModal() {
  const modal = document.getElementById('modalWrap');
  if (modal) modal.classList.add('hidden');
}

// ─────────────────────────────────────────────────────────
// WINDOW FUNCTIONS (called from index.html)
// ─────────────────────────────────────────────────────────

window.handleGoogleCredential = async (response) => {
  if (!response || !response.credential) {
    const authErr = document.getElementById('authErr');
    if (authErr) authErr.textContent = 'Sign-in cancelled.';
    const authLoading = document.getElementById('authLoading');
    if (authLoading) authLoading.style.display = 'none';
    return;
  }
  
  const authLoading = document.getElementById('authLoading');
  const authErr = document.getElementById('authErr');
  if (authLoading) authLoading.style.display = 'block';
  if (authErr) authErr.textContent = '';

  try {
    const result = await authGoogle(response.credential);

    if (!result.ok) throw new Error(result.data?.error || 'Auth failed');

    saveSession(result.data.session_token, result.data.user, result.data.token_balance);

    if (typeof applyUserToUI === 'function') applyUserToUI(currentUser);
    if (typeof setBalUI === 'function') setBalUI(balance);
    if (typeof setLed === 'function') setLed('on', 'Connected ✓');
    const sendBtn = document.getElementById('sendBtn');
    if (sendBtn) sendBtn.disabled = false;
    hideModal();
  } catch (err) {
    if (authErr) authErr.textContent = err.message || 'Sign-in failed.';
  } finally {
    if (authLoading) authLoading.style.display = 'none';
  }
};

window.continueAsGuest = async () => {
  const authLoading = document.getElementById('authLoading');
  if (authLoading) authLoading.style.display = 'block';
  
  try {
    const result = await authGuest();
    
    if (result.ok && result.data && result.data.session_token) {
      saveSession(result.data.session_token, result.data.user, result.data.token_balance);
      
      if (typeof applyUserToUI === 'function') applyUserToUI(currentUser);
      if (typeof setBalUI === 'function') setBalUI(balance);
      
      const guestBanner = document.getElementById('guestBanner');
      if (guestBanner) guestBanner.classList.add('show');
      
      if (typeof setLed === 'function') setLed('on', 'Connected ✓');
      
      const sendBtn = document.getElementById('sendBtn');
      if (sendBtn) sendBtn.disabled = false;
      
      hideModal();
    } else {
      throw new Error((result.data && result.data.error) || 'Guest auth failed');
    }
  } catch (err) {
    console.error('Guest auth error:', err);
    const authErr = document.getElementById('authErr');
    if (authErr) authErr.textContent = 'Guest sign-in failed: ' + (err.message || 'Unknown error');
  } finally {
    if (authLoading) authLoading.style.display = 'none';
  }
};

window.initiateGoogleSignIn = () => {
  const authErr = document.getElementById('authErr');
  if (authErr) authErr.textContent = '';
  
  const authLoading = document.getElementById('authLoading');
  if (authLoading) authLoading.style.display = 'block';
  
  if (typeof google !== 'undefined') {
    google.accounts.id.prompt();
  }
};

// ─────────────────────────────────────────────────────────
// GOOGLE OAUTH SETUP
// ─────────────────────────────────────────────────────────

function initGoogle() {
  if (typeof google !== 'undefined') {
    google.accounts.id.initialize({
      client_id: GOOGLE_CLIENT_ID,
      callback: window.handleGoogleCredential,
      auto_select: false,
      cancel_on_tap_outside: false,
    });
  }
}

document.addEventListener('DOMContentLoaded', initGoogle);

// ─────────────────────────────────────────────────────────
// GLOBAL TRENDING & CONTENT FUNCTIONS
// ─────────────────────────────────────────────────────────

/**
 * Send a trending topic to the chat input
 * @param {string} title - Topic title
 * @param {string} emoji - Topic emoji
 * @param {string} context - Topic context/description
 */
window.sendTopicToChat = function(title, emoji, context) {
  console.log(`📤 Sending to chat: ${title}`);
  const chatPrompt = document.getElementById('prompt');
  if (chatPrompt) {
    const prompt = `Topic: ${title} ${emoji}\n\nContext: ${context}\n\nHelp me create 3 variations of content about this topic optimized for my audience.`;
    chatPrompt.value = prompt;
    chatPrompt.focus();
    
    if (typeof switchTab === 'function') {
      switchTab('chat');
    }
    
    if (typeof showSuccessNotification === 'function') {
      showSuccessNotification('✅ Topic added to chat!');
    }
    
    console.log(`✅ Topic prompt ready: "${prompt.substring(0, 50)}..."`);
  } else {
    console.error('❌ Chat prompt element not found');
  }
};
