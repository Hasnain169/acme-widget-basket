// Product data
const products = [
    { code: 'R01', name: 'Red Widget', price: 32.95 },
    { code: 'G01', name: 'Green Widget', price: 24.95 },
    { code: 'B01', name: 'Blue Widget', price: 7.95 }
];

// Delivery charge tiers
const deliveryTiers = [
    { threshold: 90, cost: 0 },
    { threshold: 50, cost: 2.95 },
    { threshold: 0, cost: 4.95 }
];

// Offers
const offers = [
    { type: 'buyOneGetSecondHalfPrice', productCode: 'R01' }
];

// Shopping basket
let basket = [];

// DOM elements
const productListEl = document.getElementById('product-list');
const basketItemsEl = document.getElementById('basket-items');
const subtotalEl = document.getElementById('subtotal');
const discountEl = document.getElementById('discount');
const discountRowEl = document.getElementById('discount-row');
const deliveryEl = document.getElementById('delivery');
const totalEl = document.getElementById('total');
const checkoutBtn = document.getElementById('checkout-btn');
const checkoutModal = document.getElementById('checkout-modal');
const orderSummaryEl = document.getElementById('order-summary');
const confirmOrderBtn = document.getElementById('confirm-order-btn');
const closeModalBtn = document.querySelector('.close');

// Initialize the app
function init() {
    renderProducts();
    setupEventListeners();
}

// Render product list
function renderProducts() {
    productListEl.innerHTML = '';
    
    products.forEach(product => {
        const productCard = document.createElement('div');
        productCard.className = 'product-card';
        productCard.innerHTML = `
            <div class="product-code">${product.code}</div>
            <div class="product-name">${product.name}</div>
            <div class="product-price">$${product.price.toFixed(2)}</div>
            <button class="add-to-cart" data-code="${product.code}">Add to Basket</button>
        `;
        productListEl.appendChild(productCard);
    });
}

// Render basket items
function renderBasket() {
    if (basket.length === 0) {
        basketItemsEl.innerHTML = '<p class="empty-basket-message">Your basket is empty</p>';
        checkoutBtn.disabled = true;
        
        // Reset summary values to $0.00 when basket is empty
        subtotalEl.textContent = '$0.00';
        discountRowEl.style.display = 'none';
        deliveryEl.textContent = '$0.00';
        totalEl.textContent = '$0.00';
        
        return;
    }
    
    basketItemsEl.innerHTML = '';
    checkoutBtn.disabled = false;
    
    basket.forEach(item => {
        const basketItem = document.createElement('div');
        basketItem.className = 'basket-item';
        basketItem.innerHTML = `
            <div class="item-details">
                <div class="item-name">${item.product.name}</div>
                <div class="item-code">${item.product.code}</div>
            </div>
            <div class="item-quantity">
                <button class="quantity-btn decrease" data-code="${item.product.code}">-</button>
                <span class="quantity-value">${item.quantity}</span>
                <button class="quantity-btn increase" data-code="${item.product.code}">+</button>
            </div>
            <div class="item-price">$${(item.product.price * item.quantity).toFixed(2)}</div>
            <button class="remove-item" data-code="${item.product.code}">×</button>
        `;
        basketItemsEl.appendChild(basketItem);
    });
    
    updateBasketSummary();
}

// Update basket summary
function updateBasketSummary() {
    const { subtotal, discount, deliveryCharge, total } = calculateTotals();
    
    subtotalEl.textContent = `$${subtotal.toFixed(2)}`;
    
    if (discount > 0) {
        discountRowEl.style.display = 'flex';
        discountEl.textContent = `-$${discount.toFixed(2)}`;
    } else {
        discountRowEl.style.display = 'none';
    }
    
    deliveryEl.textContent = `$${deliveryCharge.toFixed(2)}`;
    totalEl.textContent = `$${total.toFixed(2)}`;
}

// Calculate basket totals
function calculateTotals() {
    // Calculate subtotal
    const subtotal = basket.reduce((sum, item) => {
        return sum + (item.product.price * item.quantity);
    }, 0);
    
    // Calculate discount
    let discount = 0;
    
    // Apply "buy one, get second half price" offer for R01
    const redWidgetOffer = offers.find(offer => 
        offer.type === 'buyOneGetSecondHalfPrice' && offer.productCode === 'R01');
    
    if (redWidgetOffer) {
        const redWidgetItem = basket.find(item => item.product.code === 'R01');
        if (redWidgetItem && redWidgetItem.quantity >= 2) {
            const pairsCount = Math.floor(redWidgetItem.quantity / 2);
            discount += pairsCount * (redWidgetItem.product.price / 2);
        }
    }
    
    // Calculate delivery charge
    const afterDiscountSubtotal = subtotal - discount;
    let deliveryCharge = deliveryTiers[deliveryTiers.length - 1].cost; // Default to highest cost
    
    for (const tier of deliveryTiers) {
        if (afterDiscountSubtotal >= tier.threshold) {
            deliveryCharge = tier.cost;
            break;
        }
    }
    
    // Calculate total
    const total = subtotal - discount + deliveryCharge;
    
    return { subtotal, discount, deliveryCharge, total };
}

// Add product to basket
function addToBasket(productCode) {
    const product = products.find(p => p.code === productCode);
    if (!product) return;
    
    const existingItem = basket.find(item => item.product.code === productCode);
    
    if (existingItem) {
        existingItem.quantity += 1;
        alert(`Added another ${product.name} to your basket!`);
    } else {
        basket.push({
            product,
            quantity: 1
        });
        alert(`${product.name} has been added to your basket!`);
    }
    
    renderBasket();
}

// Remove product from basket
function removeFromBasket(productCode) {
    const product = products.find(p => p.code === productCode);
    if (product) {
        alert(`${product.name} has been removed from your basket!`);
    }
    
    basket = basket.filter(item => item.product.code !== productCode);
    renderBasket();
}

// Update product quantity
function updateQuantity(productCode, change) {
    const item = basket.find(item => item.product.code === productCode);
    if (!item) return;
    
    item.quantity += change;
    
    if (item.quantity <= 0) {
        removeFromBasket(productCode);
    } else {
        renderBasket();
    }
}

// Show checkout modal
function showCheckoutModal() {
    const { subtotal, discount, deliveryCharge, total } = calculateTotals();
    
    let summaryHTML = '<h3>Order Items:</h3><ul>';
    
    basket.forEach(item => {
        summaryHTML += `<li>${item.quantity}x ${item.product.name} - $${(item.product.price * item.quantity).toFixed(2)}</li>`;
    });
    
    summaryHTML += `</ul>
        <div class="summary-row"><span>Subtotal:</span><span>$${subtotal.toFixed(2)}</span></div>`;
    
    if (discount > 0) {
        summaryHTML += `<div class="summary-row"><span>Discount:</span><span>-$${discount.toFixed(2)}</span></div>`;
    }
    
    summaryHTML += `<div class="summary-row"><span>Delivery:</span><span>$${deliveryCharge.toFixed(2)}</span></div>
        <div class="summary-row total"><span>Total:</span><span>$${total.toFixed(2)}</span></div>`;
    
    orderSummaryEl.innerHTML = summaryHTML;
    checkoutModal.style.display = 'block';
}

// Complete order
function completeOrder() {
    alert('Thank you for your order! It will be processed shortly.');
    basket = [];
    renderBasket();
    checkoutModal.style.display = 'none';
}

// Setup event listeners
function setupEventListeners() {
    // Add to basket buttons
    productListEl.addEventListener('click', (e) => {
        if (e.target.classList.contains('add-to-cart')) {
            const productCode = e.target.dataset.code;
            addToBasket(productCode);
        }
    });
    
    // Basket item interactions
    basketItemsEl.addEventListener('click', (e) => {
        const productCode = e.target.dataset.code;
        
        if (e.target.classList.contains('remove-item')) {
            removeFromBasket(productCode);
        } else if (e.target.classList.contains('increase')) {
            updateQuantity(productCode, 1);
        } else if (e.target.classList.contains('decrease')) {
            updateQuantity(productCode, -1);
        }
    });
    
    // Checkout button
    checkoutBtn.addEventListener('click', showCheckoutModal);
    
    // Confirm order button
    confirmOrderBtn.addEventListener('click', completeOrder);
    
    // Close modal
    closeModalBtn.addEventListener('click', () => {
        checkoutModal.style.display = 'none';
    });
    
    // Close modal when clicking outside
    window.addEventListener('click', (e) => {
        if (e.target === checkoutModal) {
            checkoutModal.style.display = 'none';
        }
    });
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', init); 