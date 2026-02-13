package plugins

import (
	"sync"
)

// ServiceRegistry is a plugin-scoped dependency injection container.
// It supports both factory-based and singleton service registration.
type ServiceRegistry struct {
	mu         sync.RWMutex
	factories  map[string]func() any
	singletons map[string]any
}

// NewServiceRegistry creates a new, empty ServiceRegistry.
func NewServiceRegistry() *ServiceRegistry {
	return &ServiceRegistry{
		factories:  make(map[string]func() any),
		singletons: make(map[string]any),
	}
}

// Register adds a factory function for the given service ID.
// Each call to Get will invoke the factory to create a new instance.
func (r *ServiceRegistry) Register(id string, factory func() any) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.factories[id] = factory
	// Remove any existing singleton so the factory takes precedence.
	delete(r.singletons, id)
}

// RegisterSingleton registers a pre-created instance as a singleton.
// Subsequent calls to Get will return this exact instance.
func (r *ServiceRegistry) RegisterSingleton(id string, instance any) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.singletons[id] = instance
	// Remove any existing factory so the singleton takes precedence.
	delete(r.factories, id)
}

// Get retrieves a service by ID. Singletons are returned directly;
// factory-registered services are instantiated on each call.
// Returns the service and true if found, or nil and false if not.
func (r *ServiceRegistry) Get(id string) (any, bool) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	// Check singletons first.
	if instance, ok := r.singletons[id]; ok {
		return instance, true
	}

	// Check factories.
	if factory, ok := r.factories[id]; ok {
		return factory(), true
	}

	return nil, false
}

// Has returns true if a service with the given ID is registered,
// either as a singleton or a factory.
func (r *ServiceRegistry) Has(id string) bool {
	r.mu.RLock()
	defer r.mu.RUnlock()

	if _, ok := r.singletons[id]; ok {
		return true
	}
	if _, ok := r.factories[id]; ok {
		return true
	}
	return false
}

// Forget removes a service registration by ID, clearing both
// the singleton and factory entries.
func (r *ServiceRegistry) Forget(id string) {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.singletons, id)
	delete(r.factories, id)
}

// Flush removes all registered services, resetting the registry.
func (r *ServiceRegistry) Flush() {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.factories = make(map[string]func() any)
	r.singletons = make(map[string]any)
}
