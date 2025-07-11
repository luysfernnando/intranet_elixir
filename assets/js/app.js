// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Funcionalidades personalizadas para a intranet
document.addEventListener('DOMContentLoaded', function() {
  // Mobile menu toggle for drawer
  const drawerToggle = document.getElementById('my-drawer-2');
  const mobileMenuBtn = document.querySelector('.btn-square.btn-ghost.lg\\:hidden');

  if (mobileMenuBtn && drawerToggle) {
    mobileMenuBtn.addEventListener('click', function () {
      drawerToggle.checked = !drawerToggle.checked;
    });
  }

  // Close drawer when clicking on overlay
  const drawerOverlay = document.querySelector('.drawer-overlay');
  if (drawerOverlay && drawerToggle) {
    drawerOverlay.addEventListener('click', function () {
      drawerToggle.checked = false;
    });
  }

  // Close drawer when clicking on menu items (mobile only)
  const menuItems = document.querySelectorAll('.drawer-side .menu a');
  menuItems.forEach(item => {
    item.addEventListener('click', function () {
      if (window.innerWidth < 1024) { // lg breakpoint
        drawerToggle.checked = false;
      }
    });
  });

  // Mobile menu toggle
  const mobileMenuButton = document.getElementById('mobile-menu-button')
  const mobileMenu = document.getElementById('mobile-menu')
  
  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', function() {
      mobileMenu.classList.toggle('hidden')
    })
  }

  // Sidebar toggle
  const sidebarToggle = document.getElementById('sidebar-toggle')
  const sidebar = document.getElementById('sidebar')
  
  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener('click', function() {
      sidebar.classList.toggle('hidden')
    })
  }

  // Auto-hide flash messages
  const flashMessages = document.querySelectorAll('.flash-message')
  flashMessages.forEach(function(message) {
    setTimeout(function() {
      message.style.opacity = '0'
      setTimeout(function() {
        message.remove()
      }, 300)
    }, 5000)
  })

  // Confirm delete actions
  const deleteButtons = document.querySelectorAll('[data-confirm]')
  deleteButtons.forEach(function(button) {
    button.addEventListener('click', function(e) {
      const message = button.getAttribute('data-confirm')
      if (!confirm(message)) {
        e.preventDefault()
      }
    })
  })

  // Theme color picker
  const colorPickers = document.querySelectorAll('.color-picker')
  colorPickers.forEach(function(picker) {
    picker.addEventListener('change', function() {
      const preview = document.getElementById('theme-preview')
      if (preview) {
        preview.style.setProperty('--color-primary', picker.value)
      }
    })
  })

  // Auto-resize textareas
  const textareas = document.querySelectorAll('textarea')
  textareas.forEach(function(textarea) {
    textarea.addEventListener('input', function() {
      textarea.style.height = 'auto'
      textarea.style.height = textarea.scrollHeight + 'px'
    })
  })

  // Search functionality
  const searchInput = document.getElementById('search-input')
  const searchResults = document.getElementById('search-results')
  
  if (searchInput && searchResults) {
    let searchTimeout
    
    searchInput.addEventListener('input', function() {
      clearTimeout(searchTimeout)
      const query = searchInput.value.trim()
      
      if (query.length < 2) {
        searchResults.innerHTML = ''
        searchResults.classList.add('hidden')
        return
      }
      
      searchTimeout = setTimeout(function() {
        // Aqui você pode implementar a busca via AJAX
        // Por enquanto, apenas mostra o resultado
        searchResults.innerHTML = '<div class="p-4 text-gray-500">Buscando...</div>'
        searchResults.classList.remove('hidden')
      }, 300)
    })
  }

  // Image upload preview
  const imageInputs = document.querySelectorAll('input[type="file"][accept*="image"]')
  imageInputs.forEach(function(input) {
    input.addEventListener('change', function(e) {
      const file = e.target.files[0]
      if (file) {
        const reader = new FileReader()
        reader.onload = function(e) {
          let preview = document.getElementById('image-preview')
          if (!preview) {
            preview = document.createElement('img')
            preview.id = 'image-preview'
            preview.className = 'mt-4 max-w-xs h-auto rounded-lg shadow-md'
            input.parentNode.appendChild(preview)
          }
          preview.src = e.target.result
        }
        reader.readAsDataURL(file)
      }
    })
  })

  // Sortable tables
  const sortableHeaders = document.querySelectorAll('[data-sortable]')
  sortableHeaders.forEach(function(header) {
    header.addEventListener('click', function() {
      const table = header.closest('table')
      const tbody = table.querySelector('tbody')
      const rows = Array.from(tbody.querySelectorAll('tr'))
      const column = header.getAttribute('data-sortable')
      const isAscending = header.classList.contains('sort-asc')
      
      rows.sort(function(a, b) {
        const aValue = a.querySelector(`[data-column="${column}"]`).textContent.trim()
        const bValue = b.querySelector(`[data-column="${column}"]`).textContent.trim()
        
        if (isAscending) {
          return bValue.localeCompare(aValue)
        } else {
          return aValue.localeCompare(bValue)
        }
      })
      
      // Remove all rows and re-add them in sorted order
      rows.forEach(function(row) {
        tbody.removeChild(row)
      })
      rows.forEach(function(row) {
        tbody.appendChild(row)
      })
      
      // Update sort indicator
      sortableHeaders.forEach(function(h) {
        h.classList.remove('sort-asc', 'sort-desc')
      })
      header.classList.add(isAscending ? 'sort-desc' : 'sort-asc')
    })
  })

  // Dropdown menus
  const dropdownToggles = document.querySelectorAll('[data-dropdown-toggle]')
  dropdownToggles.forEach(function(toggle) {
    toggle.addEventListener('click', function(e) {
      e.preventDefault()
      const dropdownId = toggle.getAttribute('data-dropdown-toggle')
      const dropdown = document.getElementById(dropdownId)
      
      if (dropdown) {
        dropdown.classList.toggle('hidden')
      }
    })
  })

  // Close dropdowns when clicking outside
  document.addEventListener('click', function(e) {
    const dropdowns = document.querySelectorAll('[id$="-dropdown"]')
    dropdowns.forEach(function(dropdown) {
      if (!dropdown.contains(e.target) && !e.target.matches('[data-dropdown-toggle]')) {
        dropdown.classList.add('hidden')
      }
    })
  })

  // Form validation
  const forms = document.querySelectorAll('form[data-validate]')
  forms.forEach(function(form) {
    form.addEventListener('submit', function(e) {
      const requiredFields = form.querySelectorAll('[required]')
      let isValid = true
      
      requiredFields.forEach(function(field) {
        if (!field.value.trim()) {
          isValid = false
          field.classList.add('border-red-500')
          
          // Add error message
          let errorMessage = field.parentNode.querySelector('.field-error')
          if (!errorMessage) {
            errorMessage = document.createElement('div')
            errorMessage.className = 'field-error text-red-500 text-sm mt-1'
            errorMessage.textContent = 'Este campo é obrigatório'
            field.parentNode.appendChild(errorMessage)
          }
        } else {
          field.classList.remove('border-red-500')
          const errorMessage = field.parentNode.querySelector('.field-error')
          if (errorMessage) {
            errorMessage.remove()
          }
        }
      })
      
      if (!isValid) {
        e.preventDefault()
      }
    })
  })

  // Auto-save draft functionality
  const draftForms = document.querySelectorAll('form[data-auto-save]')
  draftForms.forEach(function(form) {
    const inputs = form.querySelectorAll('input, textarea, select')
    
    inputs.forEach(function(input) {
      input.addEventListener('input', function() {
        clearTimeout(input.saveTimeout)
        input.saveTimeout = setTimeout(function() {
          // Aqui você pode implementar o salvamento automático
          console.log('Auto-saving draft...')
        }, 2000)
      })
    })
  })

  // Notification system
  window.showNotification = function(message, type = 'info') {
    const notification = document.createElement('div')
    notification.className = `flash-message alert-${type}`
    notification.textContent = message
    
    document.body.appendChild(notification)
    
    setTimeout(function() {
      notification.style.opacity = '0'
      setTimeout(function() {
        notification.remove()
      }, 300)
    }, 5000)
  }

  // Loading states
  const loadingButtons = document.querySelectorAll('[data-loading]')
  loadingButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      const loadingText = button.getAttribute('data-loading')
      const originalText = button.textContent
      
      button.textContent = loadingText
      button.disabled = true
      
      // Re-enable after form submission or timeout
      setTimeout(function() {
        button.textContent = originalText
        button.disabled = false
      }, 3000)
    })
  })
})
