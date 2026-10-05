function _read_template(
    filename,
    ::Type{T}
) where {T<:AbstractFloat}

    file = joinpath(
        TOY_SPECTRA_DIR,
        filename
    )

    data = CSV.File(file)

    wavelength =
        T.(data.wavelength_um)

    n_scale_heights =
        T.(data.effective_altitude_scale_heights)

    return wavelength, n_scale_heights
end





_spectrum_file(::HotJupiter) = "hot_jupiter_synthetic_transmission.csv"
_spectrum_file(::Terrestrial) = "terrestrial_synthetic_transmission.csv"
_spectrum_file(::EarthLike) = "earth_like_synthetic_transmission.csv"
_spectrum_file(::SubNeptune) = "sub_neptune_synthetic_transmission.csv"


function load_spectrum(
    planet::AbstractPlanetType;
    precision::Type{T}=Float64
) where {T<:AbstractFloat}

    filename = _spectrum_file(planet)

    # Read the appropriate artifact CSV here
    wavelength, n_scale_heights = _read_template(filename,T)

    depth = similar(wavelength)
    return PlanetSpectrum(
        planet,
        wavelength,
        n_scale_heights,
        depth

    )
end