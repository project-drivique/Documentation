-- =============================================================================
-- DRIVIQUE - INITIAL POSTGRESQL 17 SCHEMA
-- This file is for a new empty database. Version it as the first Flyway migration.
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS iam;
CREATE SCHEMA IF NOT EXISTS location;
CREATE SCHEMA IF NOT EXISTS fleet;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS rental;
CREATE SCHEMA IF NOT EXISTS contract;
CREATE SCHEMA IF NOT EXISTS billing;
CREATE SCHEMA IF NOT EXISTS support;
CREATE SCHEMA IF NOT EXISTS audit;

CREATE OR REPLACE FUNCTION core.touch_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- =============================================================================
-- DOMAIN: CORE (localization, currency, and brand)
-- =============================================================================

CREATE TABLE core.languages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX uq_languages_default ON core.languages (is_default) WHERE is_default;

CREATE TABLE core.currencies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code CHAR(3) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    symbol VARCHAR(8) NOT NULL,
    decimal_places SMALLINT NOT NULL DEFAULT 2 CHECK (decimal_places BETWEEN 0 AND 4),
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX uq_currencies_default ON core.currencies (is_default) WHERE is_default;

CREATE TABLE core.exchange_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_currency_id UUID NOT NULL REFERENCES core.currencies(id),
    to_currency_id UUID NOT NULL REFERENCES core.currencies(id),
    rate NUMERIC(18,8) NOT NULL CHECK (rate > 0),
    provider VARCHAR(80) NOT NULL,
    fetched_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (from_currency_id <> to_currency_id),
    UNIQUE (from_currency_id, to_currency_id, fetched_at)
);

CREATE TABLE core.nationalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code CHAR(2) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE core.brand_configurations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name VARCHAR(100) NOT NULL,
    logo_url VARCHAR(1000),
    favicon_url VARCHAR(1000),
    primary_color CHAR(7) NOT NULL CHECK (primary_color ~ '^#[0-9A-Fa-f]{6}$'),
    secondary_color CHAR(7) NOT NULL CHECK (secondary_color ~ '^#[0-9A-Fa-f]{6}$'),
    accent_color CHAR(7) NOT NULL CHECK (accent_color ~ '^#[0-9A-Fa-f]{6}$'),
    default_theme VARCHAR(20) NOT NULL DEFAULT 'SYSTEM' CHECK (default_theme IN ('LIGHT', 'DARK', 'SYSTEM')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX uq_brand_configurations_active ON core.brand_configurations (is_active) WHERE is_active;
CREATE TRIGGER trg_brand_configurations_updated_at BEFORE UPDATE ON core.brand_configurations
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

-- =============================================================================
-- DOMAIN: IAM (identity, access, profile, and documents)
-- =============================================================================

CREATE TABLE iam.password_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(80) NOT NULL UNIQUE,
    min_length SMALLINT NOT NULL DEFAULT 12 CHECK (min_length >= 8),
    require_uppercase BOOLEAN NOT NULL DEFAULT TRUE,
    require_number BOOLEAN NOT NULL DEFAULT TRUE,
    require_symbol BOOLEAN NOT NULL DEFAULT TRUE,
    password_history_limit SMALLINT NOT NULL DEFAULT 5 CHECK (password_history_limit >= 0),
    expiration_days SMALLINT CHECK (expiration_days IS NULL OR expiration_days > 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iam.security_settings (
    key VARCHAR(100) PRIMARY KEY,
    value VARCHAR(500) NOT NULL,
    description VARCHAR(255),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iam.document_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    requires_back BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE iam.roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iam.permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iam.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(30),
    document_type_id UUID NOT NULL REFERENCES iam.document_types(id),
    document_number VARCHAR(50) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    nationality_id UUID REFERENCES core.nationalities(id),
    password_hash VARCHAR(255) NOT NULL,
    account_status VARCHAR(30) NOT NULL DEFAULT 'PENDING_VERIFICATION'
        CHECK (account_status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'LOCKED', 'PENDING_VERIFICATION')),
    is_profile_complete BOOLEAN NOT NULL DEFAULT FALSE,
    failed_login_attempts SMALLINT NOT NULL DEFAULT 0 CHECK (failed_login_attempts >= 0),
    locked_until TIMESTAMPTZ,
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON iam.users
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE iam.user_profiles (
    user_id UUID PRIMARY KEY REFERENCES iam.users(id) ON DELETE CASCADE,
    address VARCHAR(255),
    city_of_residence VARCHAR(100),
    department_of_residence VARCHAR(100),
    postal_code VARCHAR(20),
    gender VARCHAR(20) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY')),
    emergency_contact_name VARCHAR(150),
    emergency_contact_phone VARCHAR(30),
    avatar_url VARCHAR(1000),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER trg_user_profiles_updated_at BEFORE UPDATE ON iam.user_profiles
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE iam.user_roles (
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES iam.roles(id) ON DELETE RESTRICT,
    assigned_by UUID REFERENCES iam.users(id) ON DELETE SET NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE iam.role_permissions (
    role_id UUID NOT NULL REFERENCES iam.roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES iam.permissions(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE iam.user_preferences (
    user_id UUID PRIMARY KEY REFERENCES iam.users(id) ON DELETE CASCADE,
    language_id UUID NOT NULL REFERENCES core.languages(id),
    currency_id UUID NOT NULL REFERENCES core.currencies(id),
    theme_preference VARCHAR(20) NOT NULL DEFAULT 'SYSTEM' CHECK (theme_preference IN ('LIGHT', 'DARK', 'SYSTEM')),
    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    sms_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    push_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER trg_user_preferences_updated_at BEFORE UPDATE ON iam.user_preferences
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE iam.user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    refresh_token_hash VARCHAR(255) NOT NULL UNIQUE,
    device_info VARCHAR(255),
    ip_address INET,
    user_agent VARCHAR(500),
    started_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    CHECK (expires_at > started_at)
);

CREATE TABLE iam.verification_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    purpose VARCHAR(40) NOT NULL CHECK (purpose IN ('EMAIL_VERIFICATION', 'PASSWORD_RESET', 'TWO_FACTOR_AUTH', 'EMAIL_CHANGE')),
    code_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE iam.document_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    is_final BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE iam.user_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    document_type_id UUID NOT NULL REFERENCES iam.document_types(id),
    status_id UUID NOT NULL REFERENCES iam.document_statuses(id),
    front_url VARCHAR(1000),
    back_url VARCHAR(1000),
    secure_reference VARCHAR(1000),
    sha256 CHAR(64) CHECK (sha256 IS NULL OR sha256 ~ '^[0-9A-Fa-f]{64}$'),
    mime_type VARCHAR(100),
    file_size_bytes BIGINT CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    review_notes VARCHAR(500),
    reviewed_by UUID REFERENCES iam.users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMPTZ,
    expires_at DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (front_url IS NOT NULL OR secure_reference IS NOT NULL)
);

CREATE TABLE iam.user_consents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    consent_type VARCHAR(60) NOT NULL,
    document_version VARCHAR(40) NOT NULL,
    accepted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent VARCHAR(500),
    revoked_at TIMESTAMPTZ,
    UNIQUE (user_id, consent_type, document_version)
);

-- =============================================================================
-- DOMAIN: LOCATION (cities, branches, branch access, and road restrictions)
-- =============================================================================

CREATE TABLE location.departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    country_code CHAR(2) NOT NULL DEFAULT 'CO',
    name VARCHAR(100) NOT NULL,
    UNIQUE (country_code, name)
);

CREATE TABLE location.cities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    department_id UUID NOT NULL REFERENCES location.departments(id),
    name VARCHAR(100) NOT NULL,
    has_airport BOOLEAN NOT NULL DEFAULT FALSE,
    has_terminal BOOLEAN NOT NULL DEFAULT FALSE,
    vehicle_restriction_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    vehicle_restriction_schedule VARCHAR(255),
    official_restriction_url VARCHAR(1000),
    UNIQUE (department_id, name)
);

CREATE TABLE location.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    city_id UUID NOT NULL REFERENCES location.cities(id),
    country_code CHAR(2) NOT NULL DEFAULT 'CO',
    phone VARCHAR(30),
    opening_time TIME NOT NULL DEFAULT '07:00',
    closing_time TIME NOT NULL DEFAULT '20:00',
    allows_cash_payment BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (closing_time > opening_time)
);

CREATE TABLE location.branch_users (
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    branch_id UUID NOT NULL REFERENCES location.branches(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, branch_id)
);

CREATE TABLE location.vehicle_restriction_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_id UUID NOT NULL REFERENCES location.cities(id) ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    plate_last_digit SMALLINT NOT NULL CHECK (plate_last_digit BETWEEN 0 AND 9),
    start_time TIME,
    end_time TIME,
    effective_from DATE NOT NULL DEFAULT CURRENT_DATE,
    effective_to DATE,
    CHECK (effective_to IS NULL OR effective_to >= effective_from),
    CHECK (end_time IS NULL OR start_time IS NULL OR end_time > start_time),
    UNIQUE (city_id, day_of_week, plate_last_digit, effective_from)
);

-- =============================================================================
-- DOMAIN: FLEET (vehicles, equipment, media, maintenance, favorites, reviews)
-- =============================================================================

CREATE TABLE fleet.vehicle_brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE fleet.vehicle_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255),
    icon VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE fleet.transmission_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE fleet.fuel_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE fleet.vehicle_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    allows_reservation BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE fleet.vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plate VARCHAR(10) NOT NULL UNIQUE CHECK (plate ~ '^[A-Z0-9-]+$'),
    vin VARCHAR(17) UNIQUE,
    brand_id UUID NOT NULL REFERENCES fleet.vehicle_brands(id),
    category_id UUID NOT NULL REFERENCES fleet.vehicle_categories(id),
    transmission_type_id UUID NOT NULL REFERENCES fleet.transmission_types(id),
    fuel_type_id UUID NOT NULL REFERENCES fleet.fuel_types(id),
    status_id UUID NOT NULL REFERENCES fleet.vehicle_statuses(id),
    current_branch_id UUID NOT NULL REFERENCES location.branches(id),
    model VARCHAR(100) NOT NULL,
    year SMALLINT NOT NULL CHECK (year BETWEEN 1900 AND 2100),
    color VARCHAR(50),
    passenger_capacity SMALLINT NOT NULL CHECK (passenger_capacity > 0),
    doors_count SMALLINT CHECK (doors_count > 0),
    trunk_capacity_liters INTEGER CHECK (trunk_capacity_liters >= 0),
    engine_displacement VARCHAR(40),
    description TEXT,
    mileage INTEGER NOT NULL DEFAULT 0 CHECK (mileage >= 0),
    rating_average NUMERIC(3,2) NOT NULL DEFAULT 0 CHECK (rating_average BETWEEN 0 AND 5),
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER trg_vehicles_updated_at BEFORE UPDATE ON fleet.vehicles
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE fleet.vehicle_features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    group_name VARCHAR(30) NOT NULL CHECK (group_name IN ('FEATURE', 'TECHNOLOGY')),
    icon VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE fleet.vehicle_feature_assignments (
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    feature_id UUID NOT NULL REFERENCES fleet.vehicle_features(id),
    PRIMARY KEY (vehicle_id, feature_id)
);

CREATE TABLE fleet.vehicle_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    url VARCHAR(1000) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    display_order SMALLINT NOT NULL DEFAULT 1 CHECK (display_order > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (vehicle_id, display_order)
);
CREATE UNIQUE INDEX uq_vehicle_images_primary ON fleet.vehicle_images (vehicle_id) WHERE is_primary;

CREATE TABLE fleet.vehicle_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    document_type VARCHAR(30) NOT NULL CHECK (document_type IN (
        'SOAT', 'TECHNICAL_INSPECTION', 'REGISTRATION', 'INSURANCE', 'OTHER'
    )),
    document_number VARCHAR(100),
    file_url VARCHAR(1000) NOT NULL,
    issued_at DATE,
    expires_at DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    verified_at TIMESTAMPTZ,
    verified_by UUID REFERENCES iam.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (expires_at IS NULL OR issued_at IS NULL OR expires_at >= issued_at)
);
CREATE UNIQUE INDEX uq_vehicle_documents_active_type
ON fleet.vehicle_documents (vehicle_id, document_type) WHERE is_active;
CREATE INDEX idx_vehicle_documents_expiration
ON fleet.vehicle_documents (expires_at) WHERE is_active AND expires_at IS NOT NULL;

CREATE TABLE fleet.maintenance_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE fleet.vehicle_maintenances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id),
    maintenance_type_id UUID NOT NULL REFERENCES fleet.maintenance_types(id),
    scheduled_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    cost NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (cost >= 0),
    description TEXT,
    created_by UUID REFERENCES iam.users(id),
    CHECK (completed_at IS NULL OR completed_at >= scheduled_at)
);

CREATE TABLE fleet.user_favorite_vehicles (
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, vehicle_id)
);

CREATE TABLE fleet.vehicle_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id),
    user_id UUID NOT NULL REFERENCES iam.users(id),
    reservation_id UUID UNIQUE,
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- DOMAIN: CATALOG (rates, coverage, services, promotions)
-- =============================================================================

CREATE TABLE catalog.insurance_coverages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    daily_rate NUMERIC(12,2) NOT NULL CHECK (daily_rate >= 0),
    deductible_amount NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (deductible_amount >= 0),
    deductible_percentage NUMERIC(5,2) CHECK (deductible_percentage BETWEEN 0 AND 100),
    maximum_coverage_amount NUMERIC(14,2) CHECK (maximum_coverage_amount >= 0),
    is_mandatory BOOLEAN NOT NULL DEFAULT FALSE,
    benefits JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE catalog.mileage_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('LIMITED', 'UNLIMITED')),
    included_kilometers INTEGER CHECK (included_kilometers IS NULL OR included_kilometers > 0),
    daily_rate NUMERIC(12,2) NOT NULL CHECK (daily_rate >= 0),
    excess_kilometer_rate NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (excess_kilometer_rate >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK ((plan_type = 'LIMITED' AND included_kilometers IS NOT NULL) OR (plan_type = 'UNLIMITED' AND included_kilometers IS NULL))
);

CREATE TABLE catalog.additional_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    billing_type VARCHAR(20) NOT NULL DEFAULT 'PER_DAY' CHECK (billing_type IN ('PER_DAY', 'PER_EVENT', 'PER_TRIP')),
    daily_rate NUMERIC(12,2) NOT NULL CHECK (daily_rate >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE catalog.vehicle_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    mileage_plan_id UUID NOT NULL REFERENCES catalog.mileage_plans(id),
    daily_rate NUMERIC(12,2) NOT NULL CHECK (daily_rate >= 0),
    excess_kilometer_rate NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (excess_kilometer_rate >= 0),
    effective_from TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMPTZ,
    CHECK (effective_to IS NULL OR effective_to > effective_from),
    UNIQUE (vehicle_id, mileage_plan_id, effective_from)
);

CREATE TABLE catalog.vehicle_coverages (
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    coverage_id UUID NOT NULL REFERENCES catalog.insurance_coverages(id),
    daily_rate NUMERIC(12,2) NOT NULL CHECK (daily_rate >= 0),
    PRIMARY KEY (vehicle_id, coverage_id)
);

CREATE TABLE catalog.vehicle_additional_services (
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES catalog.additional_services(id),
    rate NUMERIC(12,2) NOT NULL CHECK (rate >= 0),
    PRIMARY KEY (vehicle_id, service_id)
);

CREATE TABLE catalog.promotions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    description VARCHAR(500),
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value NUMERIC(12,2) NOT NULL CHECK (discount_value > 0),
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    usage_limit INTEGER CHECK (usage_limit IS NULL OR usage_limit > 0),
    per_user_limit INTEGER CHECK (per_user_limit IS NULL OR per_user_limit > 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (ends_at > starts_at),
    CHECK (discount_type <> 'PERCENTAGE' OR discount_value <= 100)
);

-- =============================================================================
-- DOMAIN: RENTAL (availability, reservations, delivery, and extensions)
-- =============================================================================

CREATE TABLE rental.reservation_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    blocks_availability BOOLEAN NOT NULL DEFAULT FALSE,
    is_final BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE rental.reservation_status_transitions (
    from_status_id UUID NOT NULL REFERENCES rental.reservation_statuses(id) ON DELETE CASCADE,
    to_status_id UUID NOT NULL REFERENCES rental.reservation_statuses(id) ON DELETE CASCADE,
    PRIMARY KEY (from_status_id, to_status_id),
    CHECK (from_status_id <> to_status_id)
);

CREATE TABLE rental.reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    customer_id UUID NOT NULL REFERENCES iam.users(id),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id),
    status_id UUID NOT NULL REFERENCES rental.reservation_statuses(id),
    pickup_branch_id UUID NOT NULL REFERENCES location.branches(id),
    return_branch_id UUID NOT NULL REFERENCES location.branches(id),
    coverage_id UUID REFERENCES catalog.insurance_coverages(id),
    mileage_plan_id UUID REFERENCES catalog.mileage_plans(id),
    pickup_at TIMESTAMPTZ NOT NULL,
    return_at TIMESTAMPTZ NOT NULL,
    rental_period TSTZRANGE GENERATED ALWAYS AS (tstzrange(pickup_at, return_at, '[)')) STORED,
    blocks_availability BOOLEAN NOT NULL DEFAULT FALSE,
    daily_rate NUMERIC(12,2) NOT NULL CHECK (daily_rate >= 0),
    coverage_daily_rate NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (coverage_daily_rate >= 0),
    mileage_daily_rate NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (mileage_daily_rate >= 0),
    estimated_total NUMERIC(14,2) NOT NULL CHECK (estimated_total >= 0),
    notes VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (return_at > pickup_at),
    EXCLUDE USING gist (vehicle_id WITH =, rental_period WITH &&) WHERE (blocks_availability)
);
CREATE TRIGGER trg_reservations_updated_at BEFORE UPDATE ON rental.reservations
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE rental.reservation_delivery_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES rental.reservations(id) ON DELETE CASCADE,
    point_type VARCHAR(10) NOT NULL CHECK (point_type IN ('PICKUP', 'RETURN')),
    modality VARCHAR(20) NOT NULL CHECK (modality IN ('BRANCH', 'HOME', 'AIRPORT', 'TERMINAL')),
    branch_id UUID REFERENCES location.branches(id),
    city_id UUID REFERENCES location.cities(id),
    neighborhood VARCHAR(120),
    address VARCHAR(255),
    transport_reference VARCHAR(60),
    reference_details VARCHAR(500),
    UNIQUE (reservation_id, point_type),
    CHECK (
        (modality = 'BRANCH' AND branch_id IS NOT NULL AND city_id IS NULL AND address IS NULL)
        OR (modality = 'HOME' AND city_id IS NOT NULL AND address IS NOT NULL)
        OR (modality IN ('AIRPORT', 'TERMINAL') AND city_id IS NOT NULL)
    )
);

CREATE TABLE rental.reservation_additional_services (
    reservation_id UUID NOT NULL REFERENCES rental.reservations(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES catalog.additional_services(id),
    quantity SMALLINT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    rate NUMERIC(12,2) NOT NULL CHECK (rate >= 0),
    PRIMARY KEY (reservation_id, service_id)
);

CREATE TABLE rental.reservation_promotions (
    reservation_id UUID NOT NULL REFERENCES rental.reservations(id) ON DELETE CASCADE,
    promotion_id UUID NOT NULL REFERENCES catalog.promotions(id),
    discount_amount NUMERIC(12,2) NOT NULL CHECK (discount_amount >= 0),
    PRIMARY KEY (reservation_id, promotion_id)
);

CREATE TABLE rental.reservation_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES rental.reservations(id) ON DELETE CASCADE,
    previous_status_id UUID REFERENCES rental.reservation_statuses(id),
    new_status_id UUID NOT NULL REFERENCES rental.reservation_statuses(id),
    changed_by UUID REFERENCES iam.users(id),
    reason VARCHAR(500),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rental.rental_extension_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES rental.reservations(id) ON DELETE CASCADE,
    requested_return_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED')),
    additional_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (additional_amount >= 0),
    reviewed_by UUID REFERENCES iam.users(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE fleet.vehicle_reviews
    ADD CONSTRAINT fk_vehicle_reviews_reservation
    FOREIGN KEY (reservation_id) REFERENCES rental.reservations(id) ON DELETE SET NULL;

-- =============================================================================
-- DOMAIN: CONTRACT (legal contracts, versions, signatures, inspection)
-- =============================================================================

CREATE TABLE contract.contract_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    is_final BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE contract.rental_contracts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_number VARCHAR(30) NOT NULL UNIQUE,
    reservation_id UUID NOT NULL UNIQUE REFERENCES rental.reservations(id),
    customer_id UUID NOT NULL REFERENCES iam.users(id),
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id),
    status_id UUID NOT NULL REFERENCES contract.contract_statuses(id),
    pickup_branch_id UUID NOT NULL REFERENCES location.branches(id),
    return_branch_id UUID NOT NULL REFERENCES location.branches(id),
    scheduled_start_at TIMESTAMPTZ NOT NULL,
    scheduled_end_at TIMESTAMPTZ NOT NULL,
    actual_start_at TIMESTAMPTZ,
    actual_end_at TIMESTAMPTZ,
    base_amount NUMERIC(14,2) NOT NULL CHECK (base_amount >= 0),
    security_deposit NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (security_deposit >= 0),
    final_amount NUMERIC(14,2) CHECK (final_amount IS NULL OR final_amount >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (scheduled_end_at > scheduled_start_at),
    CHECK (actual_end_at IS NULL OR actual_start_at IS NULL OR actual_end_at >= actual_start_at)
);
CREATE TRIGGER trg_rental_contracts_updated_at BEFORE UPDATE ON contract.rental_contracts
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE contract.contract_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id UUID NOT NULL REFERENCES contract.rental_contracts(id) ON DELETE RESTRICT,
    version_number SMALLINT NOT NULL CHECK (version_number > 0),
    document_url VARCHAR(1000),
    document_hash CHAR(64) CHECK (document_hash IS NULL OR document_hash ~ '^[0-9A-Fa-f]{64}$'),
    reason VARCHAR(500),
    created_by UUID REFERENCES iam.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (contract_id, version_number)
);

CREATE TABLE contract.contract_signatures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_version_id UUID NOT NULL REFERENCES contract.contract_versions(id) ON DELETE RESTRICT,
    signer_user_id UUID NOT NULL REFERENCES iam.users(id),
    signature_type VARCHAR(20) NOT NULL CHECK (signature_type IN ('DRAWN', 'ELECTRONIC', 'PLATFORM')),
    evidence_url VARCHAR(1000),
    evidence_hash CHAR(64) NOT NULL CHECK (evidence_hash ~ '^[0-9A-Fa-f]{64}$'),
    stroke_data JSONB,
    signed_city_id UUID REFERENCES location.cities(id),
    ip_address INET,
    user_agent VARCHAR(500),
    signed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (contract_version_id, signer_user_id),
    CHECK (evidence_url IS NOT NULL OR stroke_data IS NOT NULL)
);

CREATE TABLE contract.contract_clauses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    version VARCHAR(40) NOT NULL,
    display_order SMALLINT NOT NULL CHECK (display_order > 0),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (version, display_order)
);

CREATE TABLE contract.contract_clause_assignments (
    contract_version_id UUID NOT NULL REFERENCES contract.contract_versions(id) ON DELETE CASCADE,
    clause_id UUID NOT NULL REFERENCES contract.contract_clauses(id),
    PRIMARY KEY (contract_version_id, clause_id)
);

CREATE TABLE contract.vehicle_inspections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id UUID NOT NULL REFERENCES contract.rental_contracts(id) ON DELETE CASCADE,
    inspection_type VARCHAR(20) NOT NULL CHECK (inspection_type IN ('CHECK_IN', 'CHECK_OUT')),
    inspector_user_id UUID NOT NULL REFERENCES iam.users(id),
    mileage INTEGER NOT NULL CHECK (mileage >= 0),
    fuel_level_percent NUMERIC(5,2) NOT NULL CHECK (fuel_level_percent BETWEEN 0 AND 100),
    observations TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (contract_id, inspection_type)
);

CREATE TABLE contract.inspection_checklist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(120) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE contract.inspection_checklist_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inspection_id UUID NOT NULL REFERENCES contract.vehicle_inspections(id) ON DELETE CASCADE,
    checklist_item_id UUID NOT NULL REFERENCES contract.inspection_checklist_items(id),
    is_compliant BOOLEAN NOT NULL,
    observation TEXT,
    evidence_photo_url VARCHAR(1000),
    UNIQUE (inspection_id, checklist_item_id)
);

-- =============================================================================
-- DOMAIN: BILLING (virtual and cash payments, idempotency, receipts)
-- =============================================================================

CREATE TABLE billing.payment_providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    provider_type VARCHAR(20) NOT NULL CHECK (provider_type IN ('GATEWAY', 'CASH_DESK')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE billing.payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    method_type VARCHAR(20) NOT NULL CHECK (method_type IN ('VIRTUAL', 'CASH')),
    requires_cash_confirmation BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK ((method_type = 'CASH' AND requires_cash_confirmation) OR (method_type = 'VIRTUAL' AND NOT requires_cash_confirmation))
);

CREATE TABLE billing.payment_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    is_final BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE billing.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES rental.reservations(id),
    contract_id UUID REFERENCES contract.rental_contracts(id),
    payment_provider_id UUID NOT NULL REFERENCES billing.payment_providers(id),
    payment_method_id UUID NOT NULL REFERENCES billing.payment_methods(id),
    status_id UUID NOT NULL REFERENCES billing.payment_statuses(id),
    external_reference VARCHAR(150),
    idempotency_key UUID NOT NULL DEFAULT gen_random_uuid(),
    provider_transaction_id VARCHAR(150),
    provider_response_code VARCHAR(80),
    provider_response_message VARCHAR(500),
    payment_token VARCHAR(255),
    amount NUMERIC(14,2) NOT NULL CHECK (amount > 0),
    currency_id UUID NOT NULL REFERENCES core.currencies(id),
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (payment_token IS NULL OR payment_token !~ '([0-9][[:space:]-]?){13,19}')
);
CREATE UNIQUE INDEX uq_payments_provider_external_reference ON billing.payments (payment_provider_id, external_reference) WHERE external_reference IS NOT NULL;
CREATE UNIQUE INDEX uq_payments_provider_idempotency ON billing.payments (payment_provider_id, idempotency_key);
CREATE TRIGGER trg_payments_updated_at BEFORE UPDATE ON billing.payments
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE billing.payment_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID NOT NULL REFERENCES billing.payments(id) ON DELETE CASCADE,
    previous_status_id UUID REFERENCES billing.payment_statuses(id),
    new_status_id UUID NOT NULL REFERENCES billing.payment_statuses(id),
    changed_by UUID REFERENCES iam.users(id),
    source VARCHAR(20) NOT NULL DEFAULT 'SYSTEM' CHECK (source IN ('SYSTEM', 'GATEWAY', 'CASH_DESK', 'ADMIN')),
    detail VARCHAR(500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE billing.cash_confirmations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID NOT NULL UNIQUE REFERENCES billing.payments(id) ON DELETE RESTRICT,
    branch_id UUID NOT NULL REFERENCES location.branches(id),
    confirmed_by_user_id UUID NOT NULL REFERENCES iam.users(id),
    cash_reference VARCHAR(100) NOT NULL UNIQUE,
    evidence_url VARCHAR(1000),
    notes VARCHAR(500),
    confirmed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE billing.payment_receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID NOT NULL UNIQUE REFERENCES billing.payments(id) ON DELETE CASCADE,
    receipt_number VARCHAR(50) NOT NULL UNIQUE,
    document_url VARCHAR(1000) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE billing.user_saved_payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    payment_provider_id UUID NOT NULL REFERENCES billing.payment_providers(id),
    payment_token VARCHAR(255) NOT NULL UNIQUE CHECK (payment_token !~ '([0-9][[:space:]-]?){13,19}'),
    card_brand VARCHAR(40),
    last_four CHAR(4) CHECK (last_four ~ '^[0-9]{4}$'),
    expires_month SMALLINT CHECK (expires_month BETWEEN 1 AND 12),
    expires_year SMALLINT CHECK (expires_year >= 2026),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- DOMAIN: SUPPORT (tickets, incidents, notifications, ratings)
-- =============================================================================

CREATE TABLE support.ticket_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL UNIQUE,
    is_final BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE support.support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    customer_id UUID NOT NULL REFERENCES iam.users(id),
    reservation_id UUID REFERENCES rental.reservations(id),
    status_id UUID NOT NULL REFERENCES support.ticket_statuses(id),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM' CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    assigned_to UUID REFERENCES iam.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER trg_support_tickets_updated_at BEFORE UPDATE ON support.support_tickets
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE support.ticket_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id UUID NOT NULL REFERENCES support.support_tickets(id) ON DELETE CASCADE,
    author_user_id UUID REFERENCES iam.users(id) ON DELETE SET NULL,
    message TEXT NOT NULL,
    attachment_url VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE support.incident_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) NOT NULL UNIQUE,
    vehicle_id UUID NOT NULL REFERENCES fleet.vehicles(id),
    reservation_id UUID REFERENCES rental.reservations(id),
    reported_by_user_id UUID NOT NULL REFERENCES iam.users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_REVIEW', 'RESOLVED', 'CLOSED')),
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM' CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER trg_incident_reports_updated_at BEFORE UPDATE ON support.incident_reports
FOR EACH ROW EXECUTE FUNCTION core.touch_updated_at();

CREATE TABLE support.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES iam.users(id) ON DELETE CASCADE,
    channel VARCHAR(20) NOT NULL DEFAULT 'IN_APP' CHECK (channel IN ('EMAIL', 'SMS', 'PUSH', 'IN_APP')),
    notification_type VARCHAR(30) NOT NULL DEFAULT 'GENERAL',
    subject VARCHAR(255),
    message TEXT NOT NULL,
    reference_type VARCHAR(50),
    reference_id UUID,
    sent_at TIMESTAMPTZ,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE support.branch_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID NOT NULL REFERENCES location.branches(id),
    user_id UUID NOT NULL REFERENCES iam.users(id),
    reservation_id UUID REFERENCES rental.reservations(id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(1000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- DOMAIN: AUDIT (administrative reports and immutable operational audit)
-- =============================================================================

CREATE TABLE audit.report_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE audit.generated_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_type_id UUID NOT NULL REFERENCES audit.report_types(id),
    generated_by UUID NOT NULL REFERENCES iam.users(id),
    output_format VARCHAR(20) NOT NULL CHECK (output_format IN ('PDF', 'XLSX', 'CSV')),
    filters JSONB NOT NULL DEFAULT '{}'::jsonb,
    file_url VARCHAR(1000) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_name VARCHAR(50) NOT NULL,
    entity_name VARCHAR(128) NOT NULL,
    entity_id UUID,
    operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    result VARCHAR(20) NOT NULL DEFAULT 'SUCCESS' CHECK (result IN ('SUCCESS', 'FAILURE')),
    actor_user_id UUID REFERENCES iam.users(id) ON DELETE SET NULL,
    branch_id UUID REFERENCES location.branches(id) ON DELETE SET NULL,
    ip_address INET,
    description TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- INTEGRITY TRIGGERS
-- =============================================================================

CREATE OR REPLACE FUNCTION rental.validate_reservation_status_change()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE vehicle_is_reservable BOOLEAN;
BEGIN
    IF TG_OP = 'UPDATE' AND NEW.status_id IS DISTINCT FROM OLD.status_id
       AND NOT EXISTS (
           SELECT 1
           FROM rental.reservation_status_transitions transition
           WHERE transition.from_status_id = OLD.status_id
             AND transition.to_status_id = NEW.status_id
       ) THEN
        RAISE EXCEPTION 'Reservation status transition is not allowed' USING ERRCODE = '23514';
    END IF;

    SELECT blocks_availability INTO NEW.blocks_availability
    FROM rental.reservation_statuses WHERE id = NEW.status_id;
    IF NEW.blocks_availability IS NULL THEN
        RAISE EXCEPTION 'Invalid reservation status' USING ERRCODE = '23503';
    END IF;
    IF NEW.blocks_availability THEN
        SELECT vehicle.is_active AND vehicle_status.allows_reservation INTO vehicle_is_reservable
        FROM fleet.vehicles AS vehicle
        JOIN fleet.vehicle_statuses AS vehicle_status ON vehicle_status.id = vehicle.status_id
        WHERE vehicle.id = NEW.vehicle_id;
        IF vehicle_is_reservable IS DISTINCT FROM TRUE THEN
            RAISE EXCEPTION 'Vehicle is not available for a blocking reservation' USING ERRCODE = '23514';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_reservations_availability BEFORE INSERT OR UPDATE OF status_id ON rental.reservations
FOR EACH ROW EXECUTE FUNCTION rental.validate_reservation_status_change();

CREATE OR REPLACE FUNCTION rental.write_reservation_status_history()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'INSERT' OR NEW.status_id IS DISTINCT FROM OLD.status_id THEN
        INSERT INTO rental.reservation_status_history (reservation_id, previous_status_id, new_status_id)
        VALUES (NEW.id, CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE OLD.status_id END, NEW.status_id);
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_reservations_status_history AFTER INSERT OR UPDATE OF status_id ON rental.reservations
FOR EACH ROW EXECUTE FUNCTION rental.write_reservation_status_history();

CREATE OR REPLACE FUNCTION rental.validate_delivery_point()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE expected_branch_id UUID;
BEGIN
    IF NEW.modality = 'BRANCH' THEN
        SELECT CASE NEW.point_type
            WHEN 'PICKUP' THEN pickup_branch_id
            ELSE return_branch_id
        END INTO expected_branch_id
        FROM rental.reservations WHERE id = NEW.reservation_id;
        IF NEW.branch_id IS DISTINCT FROM expected_branch_id THEN
            RAISE EXCEPTION 'Branch delivery point must match the reservation branch' USING ERRCODE = '23514';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_reservation_delivery_points_validate BEFORE INSERT OR UPDATE ON rental.reservation_delivery_points
FOR EACH ROW EXECUTE FUNCTION rental.validate_delivery_point();

CREATE OR REPLACE FUNCTION fleet.validate_vehicle_review()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE reservation_customer_id UUID; reservation_vehicle_id UUID; reservation_status_code VARCHAR(40);
BEGIN
    IF NEW.reservation_id IS NULL THEN
        RETURN NEW;
    END IF;
    SELECT reservation.customer_id, reservation.vehicle_id, status.code
    INTO reservation_customer_id, reservation_vehicle_id, reservation_status_code
    FROM rental.reservations AS reservation
    JOIN rental.reservation_statuses AS status ON status.id = reservation.status_id
    WHERE reservation.id = NEW.reservation_id;
    IF NOT FOUND OR NEW.user_id IS DISTINCT FROM reservation_customer_id
       OR NEW.vehicle_id IS DISTINCT FROM reservation_vehicle_id
       OR reservation_status_code <> 'COMPLETED' THEN
        RAISE EXCEPTION 'A review must belong to its completed reservation, customer, and vehicle' USING ERRCODE = '23514';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_vehicle_reviews_validate BEFORE INSERT OR UPDATE ON fleet.vehicle_reviews
FOR EACH ROW EXECUTE FUNCTION fleet.validate_vehicle_review();

CREATE OR REPLACE FUNCTION contract.validate_contract_reservation()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE r RECORD;
BEGIN
    IF TG_OP = 'UPDATE' AND NEW.reservation_id IS DISTINCT FROM OLD.reservation_id THEN
        RAISE EXCEPTION 'Contract reservation is immutable' USING ERRCODE = '23514';
    END IF;
    SELECT customer_id, vehicle_id, pickup_branch_id, return_branch_id, pickup_at, return_at
    INTO r FROM rental.reservations WHERE id = NEW.reservation_id;
    IF NOT FOUND OR NEW.customer_id IS DISTINCT FROM r.customer_id OR NEW.vehicle_id IS DISTINCT FROM r.vehicle_id
       OR NEW.pickup_branch_id IS DISTINCT FROM r.pickup_branch_id OR NEW.return_branch_id IS DISTINCT FROM r.return_branch_id
       OR NEW.scheduled_start_at IS DISTINCT FROM r.pickup_at OR NEW.scheduled_end_at IS DISTINCT FROM r.return_at THEN
        RAISE EXCEPTION 'Contract must match its reservation' USING ERRCODE = '23514';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_contracts_validate_reservation BEFORE INSERT OR UPDATE ON contract.rental_contracts
FOR EACH ROW EXECUTE FUNCTION contract.validate_contract_reservation();

CREATE OR REPLACE FUNCTION contract.prevent_version_or_signature_mutation()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Contract versions and signatures are immutable' USING ERRCODE = '23514';
END;
$$;
CREATE TRIGGER trg_contract_versions_immutable BEFORE UPDATE OR DELETE ON contract.contract_versions
FOR EACH ROW EXECUTE FUNCTION contract.prevent_version_or_signature_mutation();
CREATE TRIGGER trg_contract_signatures_immutable BEFORE UPDATE OR DELETE ON contract.contract_signatures
FOR EACH ROW EXECUTE FUNCTION contract.prevent_version_or_signature_mutation();

CREATE OR REPLACE FUNCTION billing.validate_payment()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    contract_reservation UUID;
    method_type VARCHAR(20);
    provider_type VARCHAR(20);
BEGIN
    IF NEW.contract_id IS NOT NULL THEN
        SELECT reservation_id INTO contract_reservation FROM contract.rental_contracts WHERE id = NEW.contract_id;
        IF NOT FOUND OR contract_reservation IS DISTINCT FROM NEW.reservation_id THEN
            RAISE EXCEPTION 'Payment contract must belong to payment reservation' USING ERRCODE = '23514';
        END IF;
    END IF;

    SELECT payment_method.method_type INTO method_type
    FROM billing.payment_methods AS payment_method
    WHERE payment_method.id = NEW.payment_method_id;
    SELECT payment_provider.provider_type INTO provider_type
    FROM billing.payment_providers AS payment_provider
    WHERE payment_provider.id = NEW.payment_provider_id;
    IF (method_type = 'CASH' AND provider_type <> 'CASH_DESK')
       OR (method_type = 'VIRTUAL' AND provider_type <> 'GATEWAY') THEN
        RAISE EXCEPTION 'Payment method and provider are incompatible' USING ERRCODE = '23514';
    END IF;

    IF method_type = 'CASH' AND (NEW.external_reference IS NOT NULL OR NEW.payment_token IS NOT NULL) THEN
        RAISE EXCEPTION 'Cash payments cannot contain gateway references or payment tokens' USING ERRCODE = '23514';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_payments_validate_links BEFORE INSERT OR UPDATE OF reservation_id, contract_id, payment_provider_id, payment_method_id, external_reference, payment_token ON billing.payments
FOR EACH ROW EXECUTE FUNCTION billing.validate_payment();

CREATE OR REPLACE FUNCTION billing.write_payment_status_history()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'INSERT' OR NEW.status_id IS DISTINCT FROM OLD.status_id THEN
        INSERT INTO billing.payment_status_history (payment_id, previous_status_id, new_status_id)
        VALUES (NEW.id, CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE OLD.status_id END, NEW.status_id);
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_payments_status_history AFTER INSERT OR UPDATE OF status_id ON billing.payments
FOR EACH ROW EXECUTE FUNCTION billing.write_payment_status_history();

CREATE OR REPLACE FUNCTION billing.confirm_cash_payment()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    method_type VARCHAR(20);
    confirmed_status UUID;
    branch_accepts_cash BOOLEAN;
BEGIN
    SELECT pm.method_type INTO method_type FROM billing.payments p
    JOIN billing.payment_methods pm ON pm.id = p.payment_method_id WHERE p.id = NEW.payment_id;
    IF method_type IS DISTINCT FROM 'CASH' THEN
        RAISE EXCEPTION 'Only cash payments can be confirmed at a branch' USING ERRCODE = '23514';
    END IF;
    SELECT allows_cash_payment INTO branch_accepts_cash FROM location.branches WHERE id = NEW.branch_id;
    IF NOT branch_accepts_cash THEN
        RAISE EXCEPTION 'Cash payments are not accepted at this branch' USING ERRCODE = '23514';
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM location.branch_users
        WHERE branch_id = NEW.branch_id AND user_id = NEW.confirmed_by_user_id
    ) THEN
        RAISE EXCEPTION 'Cash confirmation user is not assigned to the branch' USING ERRCODE = '23514';
    END IF;
    SELECT id INTO confirmed_status FROM billing.payment_statuses WHERE code = 'CASH_CONFIRMED';
    UPDATE billing.payments SET status_id = confirmed_status, paid_at = NEW.confirmed_at WHERE id = NEW.payment_id;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_cash_confirmations_after_insert AFTER INSERT ON billing.cash_confirmations
FOR EACH ROW EXECUTE FUNCTION billing.confirm_cash_payment();

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_users_email ON iam.users(email);
CREATE INDEX idx_user_sessions_user_expires ON iam.user_sessions(user_id, expires_at);
CREATE INDEX idx_branches_city ON location.branches(city_id);
CREATE INDEX idx_vehicles_catalog ON fleet.vehicles(category_id, current_branch_id, status_id, is_active);
CREATE INDEX idx_vehicle_reviews_vehicle ON fleet.vehicle_reviews(vehicle_id, created_at DESC);
CREATE INDEX idx_reservations_customer ON rental.reservations(customer_id, pickup_at DESC);
CREATE INDEX idx_reservations_status_dates ON rental.reservations(status_id, pickup_at, return_at);
CREATE INDEX idx_contracts_reservation ON contract.rental_contracts(reservation_id);
CREATE INDEX idx_contracts_customer_status ON contract.rental_contracts(customer_id, status_id);
CREATE INDEX idx_payments_reservation ON billing.payments(reservation_id, created_at DESC);
CREATE INDEX idx_payments_status ON billing.payments(status_id, created_at DESC);
CREATE INDEX idx_notifications_user_unread ON support.notifications(user_id, read_at) WHERE read_at IS NULL;
CREATE INDEX idx_tickets_customer_status ON support.support_tickets(customer_id, status_id);
CREATE INDEX idx_audit_logs_entity_created ON audit.audit_logs(domain_name, entity_name, created_at DESC);

-- =============================================================================
-- MINIMUM CATALOG DATA
-- =============================================================================

INSERT INTO core.languages (code, name, is_default) VALUES
    ('es', 'Spanish', TRUE), ('en', 'English', FALSE), ('fr', 'French', FALSE), ('pt-BR', 'Portuguese (Brazil)', FALSE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.currencies (code, name, symbol, is_default) VALUES
    ('COP', 'Colombian Peso', '$', TRUE), ('USD', 'US Dollar', 'US$', FALSE), ('EUR', 'Euro', 'EUR', FALSE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO iam.document_types (code, name, requires_back) VALUES
    ('CC', 'Colombian Citizenship Card', TRUE), ('CE', 'Foreign Resident Card', TRUE), ('PASSPORT', 'Passport', FALSE), ('DRIVER_LICENSE', 'Driver License', TRUE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO iam.document_statuses (code, name, is_final) VALUES
    ('PENDING', 'Pending', FALSE), ('APPROVED', 'Approved', TRUE), ('REJECTED', 'Rejected', TRUE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO iam.roles (code, name) VALUES
    ('SUPER_ADMIN', 'Super Administrator'), ('BRANCH_ADMIN', 'Branch Administrator'), ('EMPLOYEE', 'Employee'), ('CUSTOMER', 'Customer')
ON CONFLICT (code) DO NOTHING;

INSERT INTO iam.permissions (code, name, description) VALUES
    ('USERS_READ', 'Read Users', 'View user accounts and profiles'),
    ('USERS_MANAGE', 'Manage Users', 'Create, update, lock, and manage user accounts'),
    ('ROLES_MANAGE', 'Manage Roles', 'Manage roles and permission assignments'),
    ('BRAND_CONFIGURATION_MANAGE', 'Manage Brand Configuration', 'Manage platform brand settings'),
    ('BRANCHES_MANAGE', 'Manage Branches', 'Manage cities, branches, and branch staff'),
    ('FLEET_MANAGE', 'Manage Fleet', 'Manage vehicles, maintenance, and fleet catalogs'),
    ('CATALOG_MANAGE', 'Manage Catalog', 'Manage prices, coverages, services, and promotions'),
    ('RESERVATIONS_READ', 'Read Reservations', 'View reservations and availability'),
    ('RESERVATIONS_MANAGE', 'Manage Reservations', 'Create and manage reservation lifecycle'),
    ('CONTRACTS_MANAGE', 'Manage Contracts', 'Create contracts, inspections, and signatures'),
    ('PAYMENTS_MANAGE', 'Manage Payments', 'Process payments and cash confirmations'),
    ('SUPPORT_MANAGE', 'Manage Support', 'Manage tickets, incidents, and notifications'),
    ('REPORTS_READ', 'Read Reports', 'Generate and view operational reports'),
    ('AUDIT_READ', 'Read Audit Log', 'View auditable business events')
ON CONFLICT (code) DO NOTHING;

INSERT INTO iam.role_permissions (role_id, permission_id)
SELECT role.id, permission.id
FROM iam.roles AS role
CROSS JOIN iam.permissions AS permission
WHERE role.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO iam.role_permissions (role_id, permission_id)
SELECT role.id, permission.id
FROM iam.roles AS role
JOIN iam.permissions AS permission ON permission.code IN (
    'USERS_READ', 'BRANCHES_MANAGE', 'FLEET_MANAGE', 'CATALOG_MANAGE',
    'RESERVATIONS_READ', 'RESERVATIONS_MANAGE', 'CONTRACTS_MANAGE',
    'PAYMENTS_MANAGE', 'SUPPORT_MANAGE', 'REPORTS_READ'
)
WHERE role.code = 'BRANCH_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO iam.role_permissions (role_id, permission_id)
SELECT role.id, permission.id
FROM iam.roles AS role
JOIN iam.permissions AS permission ON permission.code IN (
    'RESERVATIONS_READ', 'RESERVATIONS_MANAGE', 'CONTRACTS_MANAGE', 'PAYMENTS_MANAGE', 'SUPPORT_MANAGE'
)
WHERE role.code = 'EMPLOYEE'
ON CONFLICT DO NOTHING;

INSERT INTO rental.reservation_statuses (code, name, blocks_availability, is_final) VALUES
    ('PENDING_PAYMENT', 'Pending Payment', TRUE, FALSE), ('PENDING_CASH', 'Pending Cash Payment', TRUE, FALSE),
    ('CONFIRMED', 'Confirmed', TRUE, FALSE), ('IN_PROGRESS', 'In Progress', TRUE, FALSE),
    ('COMPLETED', 'Completed', FALSE, TRUE), ('CANCELLED', 'Cancelled', FALSE, TRUE), ('EXPIRED', 'Expired', FALSE, TRUE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO rental.reservation_status_transitions (from_status_id, to_status_id)
SELECT source.id, target.id
FROM rental.reservation_statuses AS source
JOIN rental.reservation_statuses AS target ON (source.code, target.code) IN (
    ('PENDING_PAYMENT', 'CONFIRMED'), ('PENDING_PAYMENT', 'PENDING_CASH'),
    ('PENDING_PAYMENT', 'CANCELLED'), ('PENDING_PAYMENT', 'EXPIRED'),
    ('PENDING_CASH', 'CONFIRMED'), ('PENDING_CASH', 'CANCELLED'), ('PENDING_CASH', 'EXPIRED'),
    ('CONFIRMED', 'IN_PROGRESS'), ('CONFIRMED', 'CANCELLED'),
    ('IN_PROGRESS', 'COMPLETED'), ('IN_PROGRESS', 'CANCELLED')
)
ON CONFLICT DO NOTHING;

INSERT INTO contract.contract_statuses (code, name, is_active, is_final) VALUES
    ('DRAFT', 'Draft', FALSE, FALSE), ('PENDING_SIGNATURE', 'Pending Signature', TRUE, FALSE),
    ('ACTIVE', 'Active', TRUE, FALSE), ('FINALIZED', 'Finalized', FALSE, TRUE), ('CANCELLED', 'Cancelled', FALSE, TRUE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO billing.payment_providers (code, name, provider_type) VALUES
    ('WOMPI', 'Wompi', 'GATEWAY'), ('CASH_DESK', 'Branch Cash Desk', 'CASH_DESK')
ON CONFLICT (code) DO NOTHING;

INSERT INTO billing.payment_methods (code, name, method_type, requires_cash_confirmation) VALUES
    ('WOMPI', 'Wompi Checkout', 'VIRTUAL', FALSE), ('CASH', 'Cash at Branch', 'CASH', TRUE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO billing.payment_statuses (code, name, is_final) VALUES
    ('PENDING', 'Pending', FALSE), ('PENDING_CASH', 'Pending Cash Confirmation', FALSE),
    ('APPROVED', 'Approved', TRUE), ('CASH_CONFIRMED', 'Cash Confirmed', TRUE), ('DECLINED', 'Declined', TRUE), ('CANCELLED', 'Cancelled', TRUE)
ON CONFLICT (code) DO NOTHING;

INSERT INTO support.ticket_statuses (code, name, is_final) VALUES
    ('OPEN', 'Open', FALSE), ('IN_PROGRESS', 'In Progress', FALSE), ('RESOLVED', 'Resolved', TRUE), ('CLOSED', 'Closed', TRUE)
ON CONFLICT (code) DO NOTHING;
