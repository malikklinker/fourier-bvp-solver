! Purpose: Provides discrete Fourier transformation matrices

module dft

  use utility, only : fp, pi

  implicit none

contains


    function matvecprod(A,x) result(y)
        real(fp), intent(in) :: x(:), A(:,:)
        real(fp) :: y(size(A,1))
        integer :: i ! Index for loop
        integer :: rows
        rows = size (A,1)
        do i= 1, rows
           y(i) = sum(A(i, :) * x(:))
        end do
    end function matvecprod

  ! function: dft_TransMat
  ! purpose: Fill transformation matrix for a discrete Fourier transform
  !          on a given domain, and return compatible set of wavenumbers
  subroutine dft_TransMat(x,k,T)
    implicit none
    real (fp), intent(in)     :: x(:)
    real (fp), intent(out)    :: k(size(x))
    real (fp), intent(in out) :: T(size(x),size(x))

    ! Local variables
    integer :: N, i
    real (fp) :: om, dx

    ! Set sizes and base wavenumber
    N = size(x)
    dx = x(2) - x(1)
    om = 2*pi/(N*dx)

    ! Set wavenumbers
    k(1) = 0.0_fp
    do i=2,N,2
      k(i) = i*om/2
      if (i+1 <= N) then
        k(i+1) = k(i)
      end if
    end do

    T(1,:) = 1.0_fp/N
    do i=2, N,2
      T(i,:) = (2.0_fp / N) * cos(k(i) * x)
      T(i+1,:) = (2.0_fp / N) * sin(k(i) * x)
    end do

  end subroutine dft_TransMat

  subroutine dft_InvTransMat(x,k,Tinv)
    implicit none
    real (fp), intent(in)     :: x(:)
    real (fp), intent(in)     :: k(size(x))
    real (fp), intent(in out) :: Tinv(size(x),size(x))

    ! Local variables
    integer :: N, j

    N = size(x)

    Tinv(:,1) = 1.0_fp
    do j=2, N,2
      Tinv(:, j) = cos(k(j) * x)
      Tinv(:, j+1) = sin(k(j) * x)
    end do


  end subroutine dft_InvTransMat
end module dft
